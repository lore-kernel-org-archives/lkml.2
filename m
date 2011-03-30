Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1C3DZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 23:25:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50660 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1C3DZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 23:25:08 -0400
Date: Wed, 30 Mar 2011 05:25:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Shaohua Li <shaohua.li@intel.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: avoid unnecessary anon_vma lock
Message-ID: <20110330032504.GD21838@one.firstfloor.org>
References: <1301277532.3981.25.camel@sli10-conroe> <m2fwq718u4.fsf@firstfloor.org> <20110329153517.3b87842f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329153517.3b87842f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 03:35:17PM -0700, Andrew Morton wrote:
> On Mon, 28 Mar 2011 09:57:39 -0700
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Shaohua Li <shaohua.li@intel.com> writes:
> > 
> > > If we only change vma->vm_end, we can avoid taking anon_vma lock even 'insert'
> > > isn't NULL, which is the case of split_vma.
> > > From my understanding, we need the lock before because rmap must get the
> > > 'insert' VMA when we adjust old VMA's vm_end (the 'insert' VMA is linked to
> > > anon_vma list in __insert_vm_struct before).
> > > But now this isn't true any more. The 'insert' VMA is already linked to
> > > anon_vma list in __split_vma(with anon_vma_clone()) instead of
> > > __insert_vm_struct. There is no race rmap can't get required VMAs.
> > > So the anon_vma lock is unnecessary, and this can reduce one locking in brk
> > > case and improve scalability.
> > 
> > Looks good to me.
> 
> Looks way too tricky to me.
> 
> Please review this code for maintainability.  Have we documented what
> we're doing as completely and as clearly as we are able?

I agree the comments could be improved, but the code change looked good
to me. I don't think it impacts maintainability by itself because
we already do similar magic.

-Andi
