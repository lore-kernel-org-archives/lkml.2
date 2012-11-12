Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2KLNvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:51:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2KLNvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:51:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 33/55] ARC: ptrace support
Date: Mon, 12 Nov 2012 13:51:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-3-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-3-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121351.06023.arnd@arndb.de>
X-Provags-ID: V02:K0:XSLZ2UVHn/lGGzSamCbKudPhzu5kotCb2zDzZGO2W0n
 Tgib5k7yQhYkRvIyMgNgTh0PbC3tuOH62/BD5vfktu3nPH4nqs
 3kole7oJBhg188TPBBbKbbdYIH1aFVhZbw2tTlwKEf0beL7T4n
 spg1XkDYdg0TixhJ3fSJb5L3dyFc5UCMcf80QrDyYia3InSbDt
 DRXUK/4Mrz1ZrG33nofQX8XKqwoEwFd9mX4iiHhfY3NIelYpkF
 esMLvngMNdKgZA0TuWBeXRbs6n2P8iRRqVnlcGrkJ+NdmWD8hE
 QmBFJswd3Bjw2JzxPo1xyGNARrUr/iW/+8mgzv0BqvxaGuvy37
 ORaLE5/z7cuJEtiHzCFQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +       case PTRACE_PEEKUSR:
> +               pos = addr;     /* offset in struct user_regs_struct */
> +               count = 4;      /* 1 register only */
> +               u_addr = (unsigned int __user *)data;
> +               kbuf = NULL;
> +               ret = genregs_get(child, NULL, pos, count, kbuf, u_addr);
> +               break;
> +
> +       case PTRACE_POKEUSR:
> +               pos = addr;     /* offset in struct user_regs_struct */
> +               count = 4;      /* 1 register only */
> +
> +               /* Ideally @data would have abeen a user space buffer, from
> +                * where, we do a copy_from_user.
> +                * However this request only involves one word, which courtesy
> +                * our ABI can be passed in a reg.
> +                * regset interface however expects some buffer to copyin from
> +                */
> +               kbuf = &data;
> +               u_addr = NULL;
> +
> +               ret = genregs_set(child, NULL, pos, count, kbuf, u_addr);
> +               break;
> +

I think these should be moved into regsets, as we have done for all
other new architectures. Your arch_ptrace then becomes a trivial wrapper
around ptrace_request.

	Arnd
