Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab0CPQ0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:26:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:38466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab0CPQ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:26:05 -0400
Date: Tue, 16 Mar 2010 17:26:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: RE: Failure with the 2.6.34-rc1 kernel
In-Reply-To: <AC311A8E81420D4EBC1F26E6479848FE065B7D5B@SDCEXCHANGE01.ad.amcc.com>
Message-ID: <alpine.LNX.2.00.1003161725310.18642@pobox.suse.cz>
References: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com> <alpine.LRH.2.00.1003161646590.26353@twin.jikos.cz> <AC311A8E81420D4EBC1F26E6479848FE065B7D5B@SDCEXCHANGE01.ad.amcc.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Rupjyoti Sarmah wrote:

> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz] 
> Sent: Tuesday, March 16, 2010 9:18 PM
> To: Rupjyoti Sarmah
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Failure with the 2.6.34-rc1 kernel
> 
> On Tue, 16 Mar 2010, Rupjyoti Sarmah wrote:
> 
> > We are seeing issues in booting some of our boards with this new
> kernel.
> > Kernel version upto 2.6.33 works fine on the boards like Canyonlands,
> > Katmai, Glacier etc.
> > These boards are not booting with kernel later than 2.6.33. Please let
> > me know how about fixing these issues ?
> 
> You'd need to provide at least dmesg from the working and non-working 
> cases.
> 
> Also git-bisect between 2.6.33 and 2.6.34-rc1 might help you identify
> the 
> commit that broke your hardware.

> It has been failing from this commit.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> t;h=ef1a8de8ea004a689b2aa9f5cefcba2b1a0262f2 .
> 
> Also, the u-boot restarts the board very quickly. It does not go to the
> kernel prompt at all. 
> 

That is a merge commit. There must be actuall non-merge commit that
introduced the change.

If you are sure that this particular commit brought in the change that
broke your system, you can do git bisect between
00ebfe58b002f0ff387f60c7cd23bc2b274fce1a and
ef1a8de8ea004a689b2aa9f5cefcba2b1a0262f2 to see which of the 88 commits
merged as part of ef1a8de8ea004a689b2aa9f5cefcba2b1a0262f2 is the actual
culprit.

Also adding linuxpcc-dev@ to CC.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
