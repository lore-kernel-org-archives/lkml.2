Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3AISpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:45:53 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:40202 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3AISpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:45:51 -0500
MIME-Version: 1.0
In-Reply-To: <50EDA154.6060407@pobox.com>
References: <1357668987-3610-1-git-send-email-josh.coombs@gmail.com>
	<50EDA154.6060407@pobox.com>
Date: Wed, 9 Jan 2013 13:45:50 -0500
Message-ID: <CAMW5UfaTX=2fQt=+2KiJCgnnUzeOXM4waMjYgyBj=RfQg6pDcQ@mail.gmail.com>
Subject: Re: [PATCH] Allow Marvell SATA driver to work with LEDS_TRIGGER_IDE_DISK
From: Josh Coombs <josh.coombs@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Bryan Wu <cooloney@gmail.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digging back through the archives, this came up once in 2007, Alan Cox
did not like the idea of globally adding this call into the critical
paths of libata at the time. (I've seen it done via external patches
in ata_qc_issue and ata_qc_complete for example.)  If that concern is
no longer in place, I can redo with it within libata so it'll work for
all libata driven devices similar to how it's handled for legacy IDE
drivers now.

Josh C

On Wed, Jan 9, 2013 at 11:56 AM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 01/08/2013 01:16 PM, Joshua Coombs wrote:
>>
>> Add a call to the IDE LED Trigger within the Marvell SATA driver to allow
>> Marvell SoC devices to show SATA activity via GPIO connected LEDs.
>>
>> Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
>> ---
>>   drivers/ata/sata_mv.c | 3 +++
>>   drivers/leds/Kconfig  | 3 +--
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>
>
> NAK.  This is not appropriate at the specific driver level.  This would be
> better implemented at a higher level.
>
>
>
