Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2LKIAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:00:05 -0500
Received: from cha92-13-88-165-248-19.fbx.proxad.net ([88.165.248.19]:51434
	"EHLO jigen.glandium.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752108Ab2LKIAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:00:03 -0500
Date: Tue, 11 Dec 2012 08:59:50 +0100
From: Mike Hommey <mh@glandium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, David Rientjes <rientjes@google.com>,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v3] Support volatile range for anon vma
Message-ID: <20121211075950.GA27103@glandium.org>
References: <1355193255-7217-1-git-send-email-minchan@kernel.org>
 <20121211024104.GA10523@blaptop>
 <20121211071742.GA26598@glandium.org>
 <20121211073744.GF22698@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211073744.GF22698@blaptop>
X-GPG-Fingerprint: 182E 161D 1130 B9FC CD7D  B167 E42A A04F A6AA 8C72
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 04:37:44PM +0900, Minchan Kim wrote:
> On Tue, Dec 11, 2012 at 08:17:42AM +0100, Mike Hommey wrote:
> > On Tue, Dec 11, 2012 at 11:41:04AM +0900, Minchan Kim wrote:
> > > - What's the madvise(addr, length, MADV_VOLATILE)?
> > > 
> > >   It's a hint that user deliver to kernel so kernel can *discard*
> > >   pages in a range anytime.
> > > 
> > > - What happens if user access page(ie, virtual address) discarded
> > >   by kernel?
> > > 
> > >   The user can see zero-fill-on-demand pages as if madvise(DONTNEED).
> > 
> > What happened to getting SIGBUS?
> 
> I thought it could force for user to handle signal.
> If user can receive signal, what can he do?
> Maybe he can call madivse(NOVOLATILE) in my old version but I removed it
> in this version so user don't need handle signal handling.

NOVOLATILE and signal throwing are two different and not necessarily
related needs. We (Mozilla) could probably live without NOVOLATILE,
but certainly not without signal throwing.

Mike
