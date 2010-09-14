Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0INWX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:23:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52892 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0INWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:23:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=N9SRYq/ZToy+0r4ewiM1lDZAco5lLTJBfJFBsFyftFqLF5BGPqaLIDUqbJQfeDeYZc
         D9h1RZQB6iXPSIeQralW28Wd3/9aH0HBfuV+1Zf1q2ZRP7NJY5BS1n51w8Xk3Kl/ghzd
         OYmsalvTt1Qgx9p17nLszKeOnk6rvDpMWArvI=
Message-ID: <4C8FF5DB.8000207@gmail.com>
Date: Wed, 15 Sep 2010 00:23:23 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9pre) Gecko/20100819 Lightning/1.0b2 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
References: <87eid282pj.fsf@spindle.srvr.nix>	<alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>	<alpine.LFD.2.00.1009141207310.2416@localhost6.localdomain6> <878w34qdu0.fsf@spindle.srvr.nix>
In-Reply-To: <878w34qdu0.fsf@spindle.srvr.nix>
X-Enigmail-Version: 1.1.1
OpenPGP: id=DDEB1C43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 14 Sep 2010, Thomas Gleixner said:
>> Another question. If you add hpet=verbose (or revert that commit) does
>> the printk_once in hpet_set_next_event() show up in dmesg ?
>>
>>     "hpet: compare register read back failed."

Since adding back that extra read, the box here, which previously
was showing the symptoms every couple of days, has been ok; so i'm
now ~80% sure this change was indeed the cause. Nothing new in logs. 

$ dmesg | grep -i hpet 
ACPI: HPET 00000000bfee5dc0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
ACPI: HPET id: 0x8086a201 base: 0xfed00000
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
$

artur
