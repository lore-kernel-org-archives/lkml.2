Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1BVOes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:34:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab1BVOeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:34:46 -0500
Date: Tue, 22 Feb 2011 15:34:21 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, Andi Kleen <andi@firstfloor.org>,
        Hugh Dickins <hughd@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110222143421.GX13092@random.random>
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
 <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random>
 <20110221145350.GH25382@redhat.com>
 <4D6378760200007800033104@vpn.id2.novell.com>
 <20110222134956.GU13092@random.random>
 <4D63D4CD020000780003320A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D63D4CD020000780003320A@vpn.id2.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 02:22:53PM +0000, Jan Beulich wrote:
> If everyone's okay with putting a couple of "if (xen_pv_domain())"
> into mm/fault.c - sure. I would have thought that this wouldn't be
> liked, hence the suggestion to make this depend on seeing the
> backlink be non-NULL.

I prefer the if (xen_pv_domain) so it also gets optimized away
at build time when CONFIG_XEN=n. I think it's also more self
explanatory to read.
