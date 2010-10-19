Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0JSSVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:21:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63963 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0JSSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CJrU+mOYNhaYWUIb5Oavx/9mVXTlpbMnwmfZfjRk50arhIo2fAV7BPJM/KtyGTSnzd
         ZxrD0gtz2JkjCkgnOLfu8xrmy2mf0tjj8clrLLbvM4Ze9f1iNXH1t497XJkNkYHmdVWd
         oVMYlcrfEBU4wpKvxT7wWsTSlkVgNSWXbeADs=
Message-ID: <4CBDE1C1.4020204@lwfinger.net>
Date: Tue, 19 Oct 2010 13:21:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
References: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net> <1287504505.1084.23.camel@i7.infradead.org> <4CBDC6AF.3060902@lwfinger.net> <201010191935.40788.arnd@arndb.de>
In-Reply-To: <201010191935.40788.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 12:35 PM, Arnd Bergmann wrote:
> On Tuesday 19 October 2010 18:26:23 Larry Finger wrote:
>> The license information that I put into WHENCE is in the source-code file that
>> contains the MODULE_LICENSE(GPL) statement. As the firmware header file is part
>> of that set of files, I thought the GPL license would apply to all. Is that not
>> so? If not, I'm not sure how to proceed.
> 
> In theory, the person that added the firmware files to the kernel under the
> terms of the GPL or anyone who distributed them before should be able to provide
> the source code for the firmware.
>
> If you think that the driver has been developed legally, just ask the author
> of the firmware for the source and add it to your patch.


I was the one that added the drive, including the firmware file, to the kernel.
I know the driver was developed legally. I took source files that contain a GPL
license (including the firmware source) from the Realtek public site, cleaned up
the driver, added a copyright for my changes, and got permission from Realtek to
submit the result to the staging directory through Greg K-H. Greg requested a
TODO item to take the firmware currently embedded in a header file with 10,197
lines and 734,033 characters, extract it from the driver, and submit it to
linux-firmware, which is what I'm trying to do now. Once the firmware is
accepted and distros get the new version of linux-firmware, I will submit the
changes that use the standard firmware-loading mechanism to get external
firmware, and delete that large header file. Those changes are now in use on my
system.

> If you don't think it was done correctly, try to get a license for redistributing
> the firmware as binary and list the license terms in the WHENCE file.
> 
> Hint: some files of the driver contain these "interesting" conditions:
> 
> /*
>  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
>  * Linux device driver for RTL8192U
>  *
>  * Based on the r8187 driver, which is:
>  * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of version 2 of the GNU General Public License as
>  * published by the Free Software Foundation.

That Merello copyright really has little to do with the current driver. As
Realtek included it in their source, I left it in, but consider it to be an
honorary citation.

Larry
