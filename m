Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1C2NS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:18:27 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47023 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1C2NS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:18:26 -0400
Date: Tue, 29 Mar 2011 08:18:24 -0500
From: scameron@beardog.cce.hp.com
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        scameron@beardog.cce.hp.com
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
Message-ID: <20110329131824.GH12760@beardog.cce.hp.com>
References: <4D8E36CC.7080707@fusionio.com> <AANLkTinpjfyrN0mCRZi8zPqd2=+=WGRRToFhc+MqBDSB@mail.gmail.com> <4D917D5A.5040502@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D917D5A.5040502@fusionio.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 08:34:02AM +0200, Jens Axboe wrote:
> On 2011-03-29 01:06, Linus Torvalds wrote:
> > On Sat, Mar 26, 2011 at 11:56 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> >> Hi Linus,
> >>
> >> This is the pull request for the block driver updates for 2.6.39. Two
> >> things here:
> >>
> >> - Big drbd update, as per usual...
> >> - cciss update.
> > 
> > Btw, that cciss thing causes a very annoying compiler warning:
> > 
> >   drivers/block/cciss.c: In function ‘dev_show_unique_id’:
> >   drivers/block/cciss.c:617:7: warning: ‘sn[0]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[1]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[2]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[3]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[4]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[5]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[6]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[7]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[8]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[9]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[10]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[11]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[12]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[13]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[14]’ may be used
> > uninitialized in this function
> >   drivers/block/cciss.c:617:7: warning: ‘sn[15]’ may be used
> > uninitialized in this function
> > 
> > which is because the compiler doesn't really notice that those things
> > are only used if the error return isn't being set.
> > 
> > So it's a compiler mis-feature, but the thing is, the warning could
> > easily be avoided by just writing the code more prettily.
> > 
> > Just do the memcpy() unconditionally: we know that 'drv' is a valid
> > pointer (we just loaded 'h' off it), and we're talking about a nice
> > constant 16-byte copy.
> > 
> > IOW, a patch something like the attached.
> > 
> > Untested, but it looks really obvious. Hmm?
> 
> Looks good to me. I'm curious, you get a warning in dev_show_unique_id()
> but not in dev_show_vendor() or any of the other following 4-5 functions
> written in the same style?
> 
> My gcc here does not warn for any of them. But it is very convoluted for
> what it does

Looks ok to me.

FWIW, I've also not seen warnings for any of those from gcc on several
distros (rhel5, rhel6, sles10, sles11).

The convolutedness was probably just me trying to be overly economical
though that "else" after the return and just before the snprintf is
kinda nuts.

-- steve
