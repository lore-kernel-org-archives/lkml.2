Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2KTPzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:55:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2KTPzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:55:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH 1/2] asm-generic: uaccess: allow arch to over-ride __get_user_fn()
Date: Tue, 20 Nov 2012 15:55:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1353422297-29079-1-git-send-email-vgupta@synopsys.com> <1353422297-29079-2-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1353422297-29079-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211201555.37272.arnd@arndb.de>
X-Provags-ID: V02:K0:1mynl1au71q21dFg+4xhP7ozQ2GD/Tq9uDOFwA4MWJB
 D86eCboGAzJEtHUEMfEfVNeQ1T3f4rW9TM0SS8ss+dd0X8wzp7
 NoV89aH8TJm4xeTwrWetsBXSmaMp7qcUfwwqzSi+TXAeqEX8Fj
 rvasRUdmsOhT/+BrgL84u0CW8cByc5dLV5zGa4ioAADMcpFPRm
 h0Z6IboqZ2TmI/GlHDqB9ySiGdkP76lZPdykDbjakoHQOADcxb
 12S8E0XXFYpXYgXokgclXIRG/rKDuP0RgTsmEDqq+qbxL5NI4u
 Sml5HVzFrG+vmD9Z11XZ5BlzIOlkuwEyepeJylibO9cob6Ijme
 xMvXeGnYcHxEwM1kd0q0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +#ifndef __get_user_fn
>  static inline int __get_user_fn(size_t size, const void __user *ptr, void *x)
>  {
>         size = __copy_from_user(x, ptr, size);
>         return size ? -EFAULT : size;
>  }
>  
> +#define __get_user_fn(sz, u, k)        __get_user_fn(sz, u, k)
> +
> +#endif

This is ok as well. The idea with the asm-generic __copy_from_user()
implementation is to separate out the cases where you have just
a few bytes and handle them efficiently inline. If you don't want
to do that for some reason, overriding __get_user_fn works
as well. The resulting object code should be the same.

	Arnd
