Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1CYVdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:33:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43715 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab1CYVdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=d7U7IfGqTM0gKIIiHG1KHZem7NuIsZfEuveFLw0Q1cZ+D5yAZ/hmeKe8BEGSGOtO/J
         lPn1JD4fJwfOaNDbN/WIPsicf7Vp7INeTJLwEAtKGtKk7iGCZ1hHo1I9aNnmmYS8mNhQ
         JWX7LHyo0y+nE8NOqiCFvJg1ssW9hO4ai49fs=
MIME-Version: 1.0
In-Reply-To: <20110325100822.GP3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com> <AANLkTinJH46U=ueUPs2bnuTp16Vtn_ViwDCrhsAGPQvM@mail.gmail.com>
 <20110324203523.GJ3130@pulham.picochip.com> <AANLkTi=pKfKeoQxB3Xb-kasfrs_aa2rqHyF9N0wR6H3z@mail.gmail.com>
 <20110325100822.GP3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:32:54 -0400
X-Google-Sender-Auth: mcP5D_pThZ50omr_EcaevSK-zV4
Message-ID: <AANLkTinh+A-pxYYda6W58hNR+_N_rxX5qx-KegE0OzQH@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 06:08, Jamie Iles wrote:
> On Thu, Mar 24, 2011 at 05:33:25PM -0400, Mike Frysinger wrote:
>> On Thu, Mar 24, 2011 at 16:35, Jamie Iles wrote:
>> > The way I was thinking that this sort of thing could be handled would be
>> > for the ECC to be transparent to the user.  Perhaps for bfin the OTP
>> > could be registered as 4 regions, otpa1-otpa4 which default to
>> > "single-ended".  Writing "ecc" as the format would generate the ecc and
>> > program it for that region then check the ECC when reading back.
>>
>> reads and writes atm always have ECC enabled, and the driver restricts
>> writes to the full half page (64bits).  if you wanted to be crafty,
>> you could blow individual bits in a single half page over multiple
>> writes before writing out the final ECC, but that isnt supported, and
>> no one has complained.
>
> The current version I have will do read-modify-write if the file offset
> isn't OTP word aligned so it sounds like I need to add a flag that says
> only do full word writes.

yes, only full 64bit writes are allowed.

> I guess in this framework we could make the OTP look like a single
> region of the 0x80 data pages concatenated or provide separate regions
> for each group of 0x80 pages but the control and ECC pages aren't
> directly accessible by the user.

well, in the current driver, i let people dump the ECC.  for
debugging, i think that's valuable.

> The other question that brings up is whether any compatibility with the
> old driver is required.

it's already going to be changing names ;).  but what other
compatibility are you thinking of ?  the requirements are you have to
be able to:
 - read it
 - write in full/aligned 64bit chunks
 - do an OTPLOCK ioctl (the drivers uses this to manage the first few
pages which flags all other pages as "locked")
-mike
