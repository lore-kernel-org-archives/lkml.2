Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1DTTZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:25:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44000 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab1DTTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:25:43 -0400
Date: Wed, 20 Apr 2011 13:25:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>, linux-arch@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
	expand_upwards
Message-ID: <20110420192540.GC31296@parisc-linux.org>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com> <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420112020.GA31296@parisc-linux.org> <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com> <1303308938.2587.8.camel@mulgrave.site> <alpine.DEB.2.00.1104200943580.9266@router.home> <1303311779.2587.19.camel@mulgrave.site> <alpine.DEB.2.00.1104201018360.9266@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104201018360.9266@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:22:04AM -0500, Christoph Lameter wrote:
> There is barely any testing going on at all of this since we have had this
> issue for more than 5 years and have not noticed it. The absence of bug
> reports therefore proves nothing. Code inspection of the VM shows
> that this is an issue that arises in multiple subsystems and that we have
> VM_BUG_ONs in the page allocator that should trigger for these situations.

So ... we've proven that people using these architectures use SLAB
instead of SLUB, don't enable CONFIG_DEBUG_VM and don't use hugepages
(not really a surprise ... nobody's running Oracle on these arches :-)

I don't think that qualifies as "barely any testing".  I think that's
"nobody developing the Linux MM uses one of these architectures".

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
