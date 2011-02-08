Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1BHVs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:48:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60633 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1BHVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:48:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=AB+crVU2HxITv/GhBRKd2veOKLe9qlk/zXrjgEX3EJTDtmG9HSmvyI2CdUuOWxkrN8
         PvKSKEDG1k564L7IF0CH8hUIy1YMo1iE+XHtQphpUcEeDCsUncCk2imibmIOoiWNrV2d
         QHqlNf6gZAxQpc7Pfslw4IJjVCj55rdQDGLDw=
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Message-Id: <69DE7FE9-2298-4531-8684-777D6A3487A4@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen flicker like its broken or half plugged in
Date: Tue, 8 Feb 2011 13:48:21 -0800
References: <4D51AD03.7030401@gmail.com> <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8, 2011, at 1:20 PM, Alex Deucher wrote:

> On Tue, Feb 8, 2011 at 3:52 PM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> With the current HEAD Im getting screen flickering really bad to  
>> point where
>> it looks like the screen is damaged and/or half plugged-in etc..
>>
>> the bisect pointed to here:
>>
>> commit 619efb105924d8cafa0c1dd9389e9ab506f5425d
>>
>> doing a git revert 619efb10592
>> gets the screen working properly again.
>> I havent looked much through the code to see if I can fix this. for  
>> the time
>> being I'll revert this on my machine with the current, until later  
>> on.
>
> The attached patch should fix it assuming I got your pci ids correct.
> I'm done with the pll stuff; too may fixes break other boards.  Just
> add a quirk table and be done with it.
>
> Alex
>
>>
>> lspci -vv shows my card info(let me know if you need anymore)
>>
>> 01:00.0 VGA compatible controller: ATI Technologies Inc M56P [Radeon
>> Mobility X1600] (prog-if 00 [VGA controller])
>>        Subsystem: Apple Computer Inc. MacBook Pro
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
>> ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 256 bytes
>>        Interrupt: pin A routed to IRQ 42
>>        Region 0: Memory at 40000000 (32-bit, prefetchable)  
>> [size=128M]
>>        Region 1: I/O ports at 3000 [size=256]
>>        Region 2: Memory at 50300000 (32-bit, non-prefetchable)  
>> [size=64K]
>>        Expansion ROM at 50320000 [disabled] [size=128K]
>>        Capabilities: <access denied>
>>        Kernel driver in use: radeon
>>        Kernel modules: radeon
>>
>>
>> Justin P. Mattock
>>
> <0001-drm-radeon-kms-fix-pll-algo-quirk-function.patch>



cool... The patch fixes it over here

Reported-and-Tested by: Justin P. Mattock<justinmattock@gmail.com>

Thanks..

Justin P. Mattock
