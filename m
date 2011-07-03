Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1GCQEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 12:04:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1GCQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 12:04:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Forbes <chrisf@ijw.co.nz>
Subject: Re: [PATCH] drivers: char: i8k: Use __packed
Date: Sun, 3 Jul 2011 18:03:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Massimo Dal Zotto <dz@debian.org>, linux-kernel@vger.kernel.org
References: <1309656605-20812-1-git-send-email-chrisf@ijw.co.nz>
In-Reply-To: <1309656605-20812-1-git-send-email-chrisf@ijw.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107031803.56124.arnd@arndb.de>
X-Provags-ID: V02:K0:2gNuYVARnpdOEUerlNMgYl3UeuDqQPLxuI6K61GtKJB
 T19rKv5lE9yu42/RclCsygJ3xQD3BwkQllLNnAe1eTeNXSWXzp
 2zGCSrJrAGU3J+HTUib5nrlEitW5FwqlUPBFQaMEW8USFJqu2f
 8UWw/fGzGeEkuwy4qENrY7U87GVR4U3IWSbl74mFe1K6Pe3M30
 ABlETswopIOMusZYhgkNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 July 2011 03:30:05 Chris Forbes wrote:
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 6e40072..d9c93d4 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -103,11 +103,11 @@ static const struct file_operations i8k_fops = {
>  
>  struct smm_regs {
>         unsigned int eax;
> -       unsigned int ebx __attribute__ ((packed));
> -       unsigned int ecx __attribute__ ((packed));
> -       unsigned int edx __attribute__ ((packed));
> -       unsigned int esi __attribute__ ((packed));
> -       unsigned int edi __attribute__ ((packed));
> +       unsigned int ebx __packed;
> +       unsigned int ecx __packed;
> +       unsigned int edx __packed;
> +       unsigned int esi __packed;
> +       unsigned int edi __packed;
>  };

The attribute is not useful at all here, because the structure is guaranteed
to be packed anyway. Better just remote the attributes without replacement.

	Arnd
