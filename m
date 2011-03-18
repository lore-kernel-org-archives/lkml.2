Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1CRKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 06:09:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36054 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab1CRKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 06:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=CfiNS3wnRNucLFHIhvZHL+USQ8rhJaNdsx+8TK4Y6G1mQ2bHrRKnLcJEvDcY/kRG+a
         4tb9jd8Kj2tncMiE4EyPiaB8ZeYtFIhfrIZGA7DtSK38NggGcAhXcAMOQdtfy9MsEYPu
         9BxUl+3fgu3m1c7hfT7u2eMTnlgf1UgJqIuFs=
Message-ID: <4D832F6A.70308@linaro.org>
Date: Fri, 18 Mar 2011 10:09:46 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roger Quadros <roger.quadros@Nokia.com>
CC: ext Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311161421.GA7843@kroah.com> <201103172311.36246.arnd@arndb.de> <4D831AEF.3020109@nokia.com> <201103181001.17308.arnd@arndb.de> <4D832BF4.9000004@nokia.com>
In-Reply-To: <4D832BF4.9000004@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 09:55 AM, Somebody in the thread at some point said:

>>> So how does the Host LAN driver know what MAC address it should use?
>>
>> This is the problem we're trying to work out. The EEPROM is not
>> present, and user space has no way of knowing which MAC address
>> to set to which device. Note that there might be multiple
>> USB devices of the same type that are indistinguishable to user
>> space, so setting the MAC address there would not be completely
>> safe.
>>
>
> And what happens if you need to use u-boot or some bootloader with
> ethernet network support?
>
> Wouldn't it be better to have the MAC address programmed at the
> bootloader level?

Generally trying to have stuff half done in bootloader and half in Linux 
makes things fragile and makes another place for trouble to hide (in 
addition to bootloader state such as U-Boot env or boot.scr or 
what-have-you needing distro control for updates).

If your bootloader is bloated enough to target network operations under 
its own steam, it's bloated enough to set a random MAC or use the same 
CPU ID scheme.  But it doesn't mean that Linux should not assert the 
state it wants when it runs.

-Andy


