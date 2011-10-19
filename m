Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1JSQPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:15:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47780 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1JSQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:15:40 -0400
Date: Wed, 19 Oct 2011 18:15:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Please include const-sections into linux-next
Message-ID: <20111019161537.GH15908@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com> <20111016033514.GC26654@one.firstfloor.org> <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com> <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org> <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:54:23AM -0500, James Bottomley wrote:
> 
> > One alternative to track it down would be to apply the attached
> > patch to the gcc, then gcc would print it out.
> 
> I think the basic problem that excites the toolchain somehow is
> sectional annotations.  Can't we just dump them and do it all in a

We already use these annotations all over. Just currently they mess up
the 'r' and 'w' bits on the sections because a few (not the majority)
of declarations mismatch the ro vs rw sections.  My patchkit was just trying
to fix up those that were wrong

So you should be already using them.

Just need to find out what triggers your toolchain with these changes.
I suspect it's some kind of toolchain bug.

> linker script?  Linker scripts seem to be much better tested.

The linker script just declares the order of the section. 
The attributes are a union of what the compiler declares.
To dump them I just use objdump --section-headers or
readelf -a usually.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
