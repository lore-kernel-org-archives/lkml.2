Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2LHIxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 03:53:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2LHIxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 03:53:46 -0500
Message-ID: <50C30016.8010803@redhat.com>
Date: Sat, 08 Dec 2012 09:53:42 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Read O_DIRECT regression in 3.7-rc8 (bisected)
References: <50C2820B.5060005@redhat.com> <alpine.LFD.2.02.1212071640510.24455@air.linux-foundation.org> <alpine.LFD.2.02.1212071656190.4272@air.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1212071656190.4272@air.linux-foundation.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 01:57 AM, Linus Torvalds wrote:
> 
> On Fri, 7 Dec 2012, Linus Torvalds wrote:
>>
>> This (TOTALLY UNTESTED) patch adds it the same iov_shorten() logic that 
>> the write side has. It does it differently (in fs/block_dev.c rather than 
>> in mm/filemap.c), but I actually suspect this is a nicer way to do it, and 
>> maybe we should do the write side truncation this way too.
> 
> Ok, rebooted and tested with your test-case, and it seems to work fine. 
> But I presume that you actually found the problem some other way, so you'd 
> want to verify that it fixes whatever original bigger issue you hit.

Yes, initially it crashed regression test for cryptsetup reencrypt tool
(direct-io is optional there) and that device reencryption case never finished.
(Which means in fact lost of access to the encrypted device for user
without some manual tweaking, so quite serious problem.)

Anyway, it works now with your patch, so

Reported-and-tested-by: Milan Broz <mbroz@redhat.com>

Thanks,
Milan
