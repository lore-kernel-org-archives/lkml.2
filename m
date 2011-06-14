Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1FNR0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:26:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56191 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1FNR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Dxc48EtcqSIF8gzSAHZcEEDzsQuUGxuWrIogmTko0BABj6/akc1nBtAs5F03dYaNb0
         ZYyQHsiHV+PQGoH3h0842f63gVL11I1BBTdO0jAs1nwsptvo8os9nohTQseRa8QOvEH6
         N9fdUUYD1+JET+vgw7N2r960pEPzvDFga6IA8=
Message-ID: <4DF799A9.8080109@gmail.com>
Date: Tue, 14 Jun 2011 19:26:01 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86, efi: Do not reserve boot services regions within
 reserved areas
References: <4DF78A22.8060405@gmail.com> <1308071118.21026.16.camel@Joe-Laptop>
In-Reply-To: <1308071118.21026.16.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 14-06-11 19:05, Joe Perches schreef:
> On Tue, 2011-06-14 at 18:19 +0200, Maarten Lankhorst wrote:
>> Commit 916f676f8dc started reserving boot service code since some systems
>> require you to keep that code around until SetVirtualAddressMap is called.
> []
>> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> Hello Maarten, just trivia.
>
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> []
>> +			memblock_dbg(PFX "Could not reserve boot area "
>> +				"[0x%llx-0x%llx)\n", start, start+size);
> I believe this should be:
>
> 			memblock_dbg(PFX "Could not reserve boot area 0x%llx-0x%llx)\n",
> 				     start, start + size - 1);
Erm, no. [x...y) means the range of x to y without including y.

Other efi code followed that convention, and the e820 code does the same, silently.

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
...
[    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)

~Maarten
