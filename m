Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2FKKWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:22:04 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:52326 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2FKKWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:22:03 -0400
Message-ID: <4FD5C6C6.30000@ladisch.de>
Date: Mon, 11 Jun 2012 12:21:58 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Boszormenyi Zoltan <zboszor@pr.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu> <4FD5A3A8.4020305@ladisch.de> <4FD5A89E.1000202@pr.hu>
In-Reply-To: <4FD5A89E.1000202@pr.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boszormenyi Zoltan wrote:
> 2012-06-11 09:52 keltezéssel, Clemens Ladisch írta:
>>> Similar errors happened during copying large files on the same
>>> machine but it seems it's enough to trigger if the total amount
>>> of data read is large enough.
>>
>> Does "large enough" mean "large enough so that they are not in the file
>> cache"?
>>
> "Large enough" means it's usually not in file system cache

If you could see a change while it's in the cache, you could rule
out the disks.

>> All caches and your memory are ECC protected,
>
> Unfortunately the memory is not with ECC.

Sorry, I misread your mail.

This means that you cannot rule out bad memory.

>> so I think it is unlikely
>> that the problem is with these.  If I had to guess, I'd point to your
>> disk (firmware) or the SATA controller.  (A bad or loose SATA cable
>> would throw CRC errors into the kernel log.  Are there any?)
>
> The disks (8 of them) are attached to 3ware 9650SE-8LPML in RAID10.
> tw_cli reports no problems.

Could you check whether the same happens with some disk connected to
the on-board SATA controller?  Or while copying around lots of data
inside a RAM disk?

>> What is the exact offset of the changed byte in the file?  (It might be
>> at a cacheline, sector, or page boundary.)
>
> The bad character is at offset 0x4b74.

That's completely random, i.e., probably an hardware error.

>> http://support.amd.com/us/Processor_TechDocs/48063_15h_Mod_00h-0Fh_Rev_Guide.pdf
>
> The "no fix planned" for every errata is saddening...

It's good news, because none of them actually matter.


Regards,
Clemens
