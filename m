Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2KPEpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:45:00 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43344 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2KPEo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:44:59 -0500
Message-ID: <50A5C4C7.4090309@pobox.com>
Date: Thu, 15 Nov 2012 23:44:55 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH 7/8] ata: highbank: mark ahci_highbank_probe as __devinit
References: <1352238933-4886-1-git-send-email-arnd@arndb.de> <1352238933-4886-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1352238933-4886-8-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:55 PM, Arnd Bergmann wrote:
> The ahci_highbank_probe function is incorrectly marked as __init,
> which means it can get discarded at boot time, which might be
> a problem if for some reason the device only becomes operational
> after loading another module.
>
> Using __devinit instead avoids seeing this warning for every build:
>
> WARNING: vmlinux.o(.data+0xf7b0): Section mismatch in reference from the
> variable ahci_highbank_driver to the function .init.text:ahci_highbank_probe()
> The variable ahci_highbank_driver references
> the function __init ahci_highbank_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> ---
>   drivers/ata/sata_highbank.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

applied


