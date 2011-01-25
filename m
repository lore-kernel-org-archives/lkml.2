Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1AYWp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:45:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53816 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1AYWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cp3qpIkyP1O1CSqo6bdmlbISIRC6ierR0/1QgeDRa1TuOA8HsQItMt5IvmVzW22NKP
         DHQYinDkohoehlfS+/+VFU470h1foIlqfoJTZWlOGnTQGzM+c3/qQlfuLXyp/gPGmg30
         URYYKqVfZu1+onRE7sF+4fcCCBXCnummACzvw=
Message-ID: <4D3F529D.8060406@pobox.com>
Date: Tue, 25 Jan 2011 17:45:49 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mark Lord <kernel@teksavvy.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu> <20110125153649.GA11386@laptop> <1295971355.4955.104.camel@mulgrave.site> <20110125170522.GA16285@laptop> <4D3F4A69.7090702@teksavvy.com> <20110125141605.43963105.rdunlap@xenotime.net>
In-Reply-To: <20110125141605.43963105.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 05:16 PM, Randy Dunlap wrote:
> On Tue, 25 Jan 2011 17:10:49 -0500 Mark Lord wrote:
>
>> On 11-01-25 12:05 PM, Ahmed S. Darwish wrote:
>>>
>>> My current x86 laptop includes the very common ATA PIIX controller.
>>
>>
>> ata_piix is just about ideal for this sort of thing.
>>
>> Except, don't use the BIOS to write the logs,
>> but rather code/use a very simple set of polling-PIO
>> functions to talk directly through the PIIX to the drive.
>>
>> Really really simple code to do that, and it would likely
>> work with anything ata-piix, and most other non-AHCI chipsets too.
>>
>> Not perfect, but probably good enough for a lot of scenarios.
>> The old hd.c driver shows how to read/write a sector at a time,
>> and that kind of code is easily converted to simply poll for completion.
>
> I don't know how/where to find it, but Rusty Russell had a version of this
> many, many years ago.

You beat me to the reply :)

http://lwn.net/Articles/9905/

but IIRC there were updates and improvements.

