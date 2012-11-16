Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2KPGXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:23:22 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53332 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2KPGXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:23:19 -0500
MIME-Version: 1.0
In-Reply-To: <50A5C4C7.4090309@pobox.com>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
	<1352238933-4886-8-git-send-email-arnd@arndb.de>
	<50A5C4C7.4090309@pobox.com>
Date: Fri, 16 Nov 2012 04:23:18 -0200
Message-ID: <CAOMZO5A4YA85ZSXG2_D9yP3+TzW0FSCU1h9WjPDzJr_Er46SrA@mail.gmail.com>
Subject: Re: [PATCH 7/8] ata: highbank: mark ahci_highbank_probe as __devinit
From: Fabio Estevam <festevam@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Fri, Nov 16, 2012 at 2:44 AM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 11/06/2012 04:55 PM, Arnd Bergmann wrote:
>>
>> The ahci_highbank_probe function is incorrectly marked as __init,
>> which means it can get discarded at boot time, which might be
>> a problem if for some reason the device only becomes operational
>> after loading another module.
>>
>> Using __devinit instead avoids seeing this warning for every build:
>>
>> WARNING: vmlinux.o(.data+0xf7b0): Section mismatch in reference from the
>> variable ahci_highbank_driver to the function
>> .init.text:ahci_highbank_probe()
>> The variable ahci_highbank_driver references
>> the function __init ahci_highbank_probe()
>> If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the
>> variable:
>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Jeff Garzik <jgarzik@redhat.com>
>> ---
>>   drivers/ata/sata_highbank.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> applied

I have also sent the same fix:
https://patchwork.kernel.org/patch/1562141/
