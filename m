Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2KFLSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:18:23 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:45996 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2KFLSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:18:21 -0500
Message-ID: <5098F1F5.5060709@ahsoftware.de>
Date: Tue, 06 Nov 2012 12:18:13 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
References: <5093A592.9070605@ahsoftware.de> <5093D069.20901@ahsoftware.de> <20121103044929.GB21829@liondog.tnic> <5094F5C5.1000000@ahsoftware.de> <20121104152133.GA16116@x1.osrc.amd.com> <5096A3A4.8070602@ahsoftware.de> <20121106091057.GC2090@x1.osrc.amd.com>
In-Reply-To: <20121106091057.GC2090@x1.osrc.amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2012 10:10, schrieb Borislav Petkov:
> On Sun, Nov 04, 2012 at 06:19:32PM +0100, Alexander Holler wrote:
>> I was remotely logged in and there aren't that many faults which
>> lead to complete stand still of hw (no reset).
>
> Right, can you retry triggering the freeze without the fglrx driver?
> Simply remove it completely so that even the possibility to load it is
> not there.

Will do. But I don't think it is fglrx. I'm using it since several years 
(just with an external graphics card before) and never had a problem 
with it. Besides that, during the hangs nothing on the display happened, 
I was logged out  and just had a remote ssh session on.

>> But as you said I can't know, the only thing I know is that a box
>> with new mb, memory and apu come to a complete stand still, and
>> such shortly after I've received an emergency message which told me
>> that a bit inside the cpu switched unexpected. Adding to that, the
>> box did the same as what it did while it received the MCE, a backup
>> from a sata-atached ssd to an usb3-hd which includes compression and
>> encryption which keeps all cores at work most of the time for several
>> hours.
>
> So do you get that MCE each time you execute that same workload?

No, up to now the MCE only was visible once. But stressing the box 
yesterday (with loads of 3 for several hours and such) revealed some 
other serious failures which all look like the stuff which happens when 
the cache (or memory) is broken (I don't know how many bits of the cache 
can be corrected until something else happens or what happens). E.g. the 
checksum of a backup is wrong, or bzip2 failed with an error which it 
suggests is because of an HW failure like bad RAM (I've never seen that 
error from bzip2 before).

I've just done a memory test using  memtest86+-4.20 for about 7h (3 
complete passes of all 16GB), no errors, so the new memory itself seems 
to be ok.

I will now to tests with leaving fglrx off.

Regards,

Alexander

