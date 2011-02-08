Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1BHSSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:18:15 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36039 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab1BHSSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BT6imf559Klb7ZE/y4HS3nkY9HkjndsR9fj/PCpCXOwiJf/Y1UlR44M8rQlxY6+aom
         0Px6TWFidmlHqeYMPkJ11FDQjJMq9ND9Me9O52cIXnqkOQTsmce5KYX4Gq4wy01rmOM3
         TZTt9G8/VwY9ZKFNRuFYck7GGMmC6LQByGjvw=
MIME-Version: 1.0
In-Reply-To: <4D51796C.8020008@ru.mvista.com>
References: <201102081652.36752.bzolnier@gmail.com>
	<4D51796C.8020008@ru.mvista.com>
Date: Tue, 8 Feb 2011 19:18:12 +0100
Message-ID: <AANLkTikyV579TRSMw_g_rTB7C641fWbdSELP9mpa30bG@mail.gmail.com>
Subject: Re: [PATCH 21/20] ata_piix: add new PIIX_FLAG_* flags
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 8, 2011 at 6:12 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> Bartlomiej Zolnierkiewicz wrote:
>
>> Turn open-coded checks in piix_set_timings() into PIIX_FLAG_* flags
>> per suggestion from Alan Cox.
>
>> Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>
> [...]
>
>> Index: b/drivers/ata/ata_piix.c
>> ===================================================================
>> --- a/drivers/ata/ata_piix.c
>> +++ b/drivers/ata/ata_piix.c
>> @@ -133,6 +133,8 @@ enum {
>>        PIIX_FLAG_CHECKINTR     = (1 << 28), /* make sure PCI INTx enabled
>> */
>>        PIIX_FLAG_SIDPR         = (1 << 29), /* SATA idx/data pair regs */
>> +       PIIX_FLAG_NO_SITRE      = (1 << 30), /* no SITRE register */
>
>   The register in question is called SIDETIM, SITRE is a bit that enables
> its use.

ICH4-M databook that I have at hand (Intel IDE PRM seems to be gone
from Intel's website, though I'm sure I have a backup _somewhere_) it
is called SLV_IDETIM so lets just stick with the current naming for
now..

Thanks,
Bartlomiej
