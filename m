Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0FIWkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:40:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41509 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0FIWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=DMAsVZk6AN1R5xHzj7KCF0yCcU8lmL1ALZjkK9LvM8UkY11rwru3Sbqs0kHKVCx8vM
         QOkfE68NA9jfw9O7fymyycIIvmTzsc4SlkJm2EZyuwkUPFBOR5L7f4BZlBIuS407sIEN
         CB5JWl2a9mOy1AlTW4Rqpuv3ym2MHa4BK80nA=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] input: fixup X86_MRST selects
Date: Wed, 9 Jun 2010 15:40:41 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2+; KDE/4.4.3; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacob Pan <jacob.jun.pan@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> <20100609152921.61fb7db9.randy.dunlap@oracle.com>
In-Reply-To: <20100609152921.61fb7db9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091540.43122.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 09, 2010 03:29:21 pm Randy Dunlap wrote:
> +++ linux-next-20100609/drivers/input/keyboard/Kconfig
> @@ -70,9 +70,10 @@ config KEYBOARD_ATARI
>  
>  config KEYBOARD_ATKBD
>         tristate "AT keyboard" if EMBEDDED || !X86
> +       depends on !X86 || (X86 && !X86_MRST)

Should it be simply 'depends on !X86_MRST' and then we could kill
'!X86_MRST' conditionals in selects?

>         default y
>         select SERIO
> -       select SERIO_LIBPS2
> +       select SERIO_LIBPS2 if !X86_MRST
>         select SERIO_I8042 if X86 && !X86_MRST
>         select SERIO_GSCPS2 if GSC
>         help

Thanks.

-- 
Dmitry
