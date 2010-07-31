Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0GaWhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 18:37:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48680 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0GaWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 18:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=maUYcMPOZNWnjgjMv9jKO+I9v3xWHMr+yvV+DRscNY6jZ514OOGG9H2M0wD2EGCRyk
         M5ehTav/dni7X4rJvs2AUrMdsbesxCjcCwZ1fVWlH2sV3CsbMksS4uRVby8TpUxWTjFC
         nTT/ReDs2ezZrCw95pqmw+wW+SG48tJ12Rpis=
Message-ID: <4C54A5A7.9080008@garzik.org>
Date: Sat, 31 Jul 2010 18:37:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ondrej Zary <linux@rainbow-software.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cyber2000fb: fix machine hang on module load
References: <201007312255.30729.linux@rainbow-software.org> <4C5493DD.7010402@garzik.org> <20100731212509.GA3633@n2100.arm.linux.org.uk>
In-Reply-To: <20100731212509.GA3633@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 05:25 PM, Russell King - ARM Linux wrote:
> On Sat, Jul 31, 2010 at 05:21:33PM -0400, Jeff Garzik wrote:
>> On 07/31/2010 04:55 PM, Ondrej Zary wrote:
>>> I was testing two CyberPro 2000 based PCI cards on x86 and the machine always
>>> hanged completely when the cyber2000fb module was loaded. It seems that the
>>> card hangs when some registers are accessed too quickly after writing RAMDAC
>>> control register. With this patch, both card work.
>>>
>>> Add delay after RAMDAC control register write to prevent hangs on module load.
>>>
>>> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>>>
>>> --- linux-2.6.35-rc2-orig/drivers/video/cyber2000fb.c	2010-06-06 05:43:24.000000000 +0200
>>> +++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-27 23:12:37.000000000 +0200
>>> @@ -436,6 +436,8 @@ static void cyber2000fb_write_ramdac_ctr
>>>    	cyber2000fb_writeb(i | 4, 0x3cf, cfb);
>>>    	cyber2000fb_writeb(val, 0x3c6, cfb);
>>>    	cyber2000fb_writeb(i, 0x3cf, cfb);
>>> +	/* prevent card lock-up observed on x86 with CyberPro 2000 */
>>> +	cyber2000fb_readb(0x3cf, cfb);
>>>    }
>>
>> IIRC, cyber2000 is basically an S3 graphics chip.
>
> No such luck.  It's a proprietary Integraphics chip, mainly used in
> ARM Netwinders some 10 years ago.  It's completely different from the
> S3 chips such as Trio64.

Ah, I stand corrected.  Maybe that was cyberfb I was remembering...

	Jeff



