Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab1BKO1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:27:11 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44781 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756439Ab1BKO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:27:09 -0500
Date: Fri, 11 Feb 2011 15:26:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: tadeusz.struk@intel.com, herbert@gondor.hengli.com.au,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com
Subject: Re: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in
 rfc4106_set_hash_subkey().
Message-ID: <20110211142647.GA3920@ucw.cz>
References: <4d502ccb.p+rKcuFjWCnBlXY9%tadeusz.struk@intel.com>
 <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102071922220.27796@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-02-07 19:24:43, Jesper Juhl wrote:
> On Mon, 7 Feb 2011, tadeusz.struk@intel.com wrote:
> 
> > From: 
> > Date: Sun, 16 Jan 2011 16:41:11 +0000
> > Subject: RE: [PATCH] rfc4106, Intel, AES-NI: Don't leak memory in rfc4106_set_hash_subkey().
> > 
> > Hi Jesper,
> > Thanks, but I think there is still a problem here. You don't want to kfree req_data
> > when the kmalloc failed. I think it should look as follows.  
> > Are you ok with this?
> > 
> Fine by me.
> 
> I was aware of the kfree(NULL) thing, but desided to leave it as is for 
> two reasons - 1) kfree(NULL) is harmless and this is an error path, so the 
> extra function call doesn't matter much. 2) I wanted to preserve 
> deallocations in the reverse order of the allocations. But sure, moving 
> that kfree is a tiny optimization of the error path, so I'm fine with it.

I don't think such optimalization is worth doing... original code is
as good but shorter and less complex...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
