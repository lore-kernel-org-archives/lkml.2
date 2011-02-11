Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1BKPHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:07:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58209 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab1BKPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:07:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FgbnMgxyNW0GcHlIhNea29rUdmbBJ/7CWB2gXjUKShQSQdcrw77r2Joo7rZ2Pdjg3l
         BxOIW7pD/xr5Smeys64SHQPtA0BbO3ITk9vlz8/7/5ukwrKv1QJsW7wzetsx1aLPByjl
         rs4hrAgiUU0oOUVn45T0UUCZuYQ1Uc5WnGc+s=
Subject: Re: [PATCH] mtd: jedec_probe: initialise make sector erase command
 variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Antony Pavlov <antony@niisi.msk.ru>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru>
References: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 17:06:27 +0200
Message-ID: <1297436787.2760.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 13:00 +0300, Antony Pavlov wrote:
> In the commit 08968041bef437ec363623cd3218c2b083537ada
>  (mtd: cfi_cmdset_0002: make sector erase command variable)
> introdused a field sector_erase_cmd. In the same commit initialisation
> of cfi->sector_erase_cmd made in cfi_chip_setup()
> (file drivers/mtd/chips/cfi_probe.c), so the CFI chip has no problem:
> 
> ...
>         cfi->cfi_mode = CFI_MODE_CFI;
>         cfi->sector_erase_cmd = CMD(0x30);
> ...
> 
> But for the JEDEC chips this initialisation is not carried out,
> so the JEDEC chips have sector_erase_cmd == 0.
> 
> It's not possible symply add the line
>         p_cfi->sector_erase_cmd = CMD(0x30);
> to the cfi_jedec_setup() function be cause CMD() macros needs
> map and cfi variables. So this patch makes necessary changes.
> 
> Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

