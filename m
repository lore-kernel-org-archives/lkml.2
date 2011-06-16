Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1FPSHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:07:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62593 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1FPSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VPiV8kH8FasX2++ECGV0d/WJXGgH7sPgqqji+pIYNGowe76h3URyrwpdWV2xMgMWP+
         2jtCSMNDjzHh6qI7VqdCUXblTSXkoRcrboEwdL5NvPqbPFIlTubVB5dtR+ERCgmiuYOu
         U/6twhGfE4rrK8771IIjMgHT7pxEjvFaCfInU=
Message-ID: <4DFA4672.5080307@lwfinger.net>
Date: Thu, 16 Jun 2011 13:07:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Paalanen <pq@iki.fi>
Subject: Re: Faking MMIO ops? Fooling a driver
References: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com> <BANLkTinUxRGkXeOtBSKi51n3Q_rZEp1gUg@mail.gmail.com>
In-Reply-To: <BANLkTinUxRGkXeOtBSKi51n3Q_rZEp1gUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 12:20 PM, Rafał Miłecki wrote:
> W dniu 16 czerwca 2011 16:44 użytkownik Rafał Miłecki
> <zajec5@gmail.com>  napisał:
>> I analyze MMIO dumps of closed source driver and found such a place:
>> W 2 3855.911536 9 0xb06003fc 0x810 0x0 0
>> R 2 3855.911540 9 0xb06003fe 0x0 0x0 0
>> W 2 3855.911541 9 0xb06003fe 0x0 0x0 0
>>
>> After translation:
>>   phy_read(0x0810) ->  0x0000
>> phy_write(0x0810)<- 0x0000
>>
>> So it's quite obvious, the driver is reading PHY register, masking it
>> and writing masked value. Unfortunately from just looking at such
>> place we can not guess the mask driver uses.
>>
>> I'd like to fake value read from 0xb06003fe to be 0xFFFF.
>> Is there some ready method for doing such a trick?
>>
>> Dump comes from Kernel hacking → Tracers → MMIO and ndiswrapper.
>
> I can see values in MMIO trace struct are filled in
> arch/x86/mm/mmio-mod.c in "pre" and "post". However still no idea how
> to hack the returned value.
>
> Should I try hacking read[bwl] instead? :|

Probably. I do not see any way to trace and modify the results for a particular 
address without special code.

FYI, my reference driver for reverse engineering has no instance of a 
read/modify/write for PHY register 0x810. Is the code in question for a PHY type 
 > 6?

Larry
