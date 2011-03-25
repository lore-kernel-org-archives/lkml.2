Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1CYW1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:27:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1CYW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:27:20 -0400
Date: Fri, 25 Mar 2011 22:27:16 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325222716.GT3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
 <AANLkTinJH46U=ueUPs2bnuTp16Vtn_ViwDCrhsAGPQvM@mail.gmail.com>
 <20110324203523.GJ3130@pulham.picochip.com>
 <AANLkTi=pKfKeoQxB3Xb-kasfrs_aa2rqHyF9N0wR6H3z@mail.gmail.com>
 <20110325100822.GP3130@pulham.picochip.com>
 <AANLkTinh+A-pxYYda6W58hNR+_N_rxX5qx-KegE0OzQH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinh+A-pxYYda6W58hNR+_N_rxX5qx-KegE0OzQH@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 05:32:54PM -0400, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 06:08, Jamie Iles wrote:
> > I guess in this framework we could make the OTP look like a single
> > region of the 0x80 data pages concatenated or provide separate regions
> > for each group of 0x80 pages but the control and ECC pages aren't
> > directly accessible by the user.
> 
> well, in the current driver, i let people dump the ECC.  for
> debugging, i think that's valuable.

Hmm, that does sound potentially useful.  In v3 I've created a single 
partition that excludes the control bits and the ecc.  How about I 
change that for the next spin so there are two partitions where the 
first contains the raw data and the second is all of the ECC lumped 
together.  It may also be useful to have a name attribute for each 
region to make this clear.

It's either that or add another ioctl() for getting the ECC but that 
doesn't feel very nice.

> > The other question that brings up is whether any compatibility with the
> > old driver is required.
> 
> it's already going to be changing names ;).  but what other
> compatibility are you thinking of ?  the requirements are you have to
> be able to:
>  - read it
>  - write in full/aligned 64bit chunks
>  - do an OTPLOCK ioctl (the drivers uses this to manage the first few
> pages which flags all other pages as "locked")

Well the current version will do all of that so I think if we add the 
ECC dumping ability then everything is there.

Jamie
