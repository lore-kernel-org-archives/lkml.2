Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1DPRCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 13:02:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42097 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1DPRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 13:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=crG1vR0rbqNm5p29+dDTJJ6qoqrlF3VZH++Nj2dYeNHo4Cj4oJZrjXlIIoHuqL6Icv
         pbrmK7wR4ZfAw9R7x9bQbbYWBT60GYW8BgW3RFhRWRcbIDfoOOXYm3dj+5ZB2kCVmbUu
         WlbOKV7vVFqbsr9JOfjHlNYZCWnXcjatUfI9k=
Message-ID: <4DA9CB83.4050000@gmail.com>
Date: Sat, 16 Apr 2011 10:01:55 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Gottfried Haider <gottfried.haider@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3
 (works in 2.6.38.3)
References: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
In-Reply-To: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2011 09:38 AM, Gottfried Haider wrote:
> Hello,
>
> I am having problems pairing bluetooth devices in 2.6.39. Scanning
> works fine (hcitool scan), but when I try to pair a device using
> "bluez-simple-agent hci0 $MAC", I receive the following error message:
> "Creating device failed: org.bluez.Error.Failed: Input/output error"
>
> The same command reliably works on a 2.6.38.3 kernel with pretty much
> the same config.
>
> According to lsusb, I have a Broadcom Bluetooth Controller with ID
> 0a5c:217f. I don't see anything related in either of the dmesgs.
> My lspci output is here: http://sukzessiv.net/x120e/
> Userspace is an up-to-date Ubuntu 11.04 beta (with bluez 4.91).
>
> If there are any debugging steps that I could do or patches to try or
> revert, let me know. Unfortunately I can't do a proper bisect since
> the machine is a netbook type.
>
> cheers,
> gohai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I'm wondering if you are hitting what I was hitting a few days ago.. the 
commit below got things working over here:
(not sure if this is in the stable yet)
http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git;a=commitdiff;h=b99faf1b798d6d0e33526fd2cef55a405c08ff09;hp=58b6e124aac64bebb2e9e1a136cbd21a5ab0485a

hope this helps,

Justin P. Mattock
