Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HVUG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 16:06:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0HVUGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 16:06:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 2/3] ptrace: add __force markup
Date: Sun, 22 Aug 2010 22:06:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282472536-7430-2-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282472536-7430-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008222206.18523.arnd@arndb.de>
X-Provags-ID: V02:K0:RNpDXQ1JMxflNTfd6/pL9q0b0uEsZxCG8dvGzP9msiC
 bg0dC+bIWMxEOQKKZGpDusBG+MODQJPzRETFe6LLYuC7Z4+lxL
 JxCGQP/cXSt+++RI8UwiVXDbQM5CJ88zWoW26qpoEX2xiso50+
 7AdIxrHmqtt5j1wYBCDLB2aNet/bshlFfg1ptLyPMh+e7gyQJL
 JyjQc9KwhgroTgf7gYSCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 August 2010 12:22:15 Namhyung Kim wrote:
> index 4afd9b8..1abbb4d 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -580,18 +580,19 @@ int ptrace_request(struct task_struct *child, long request,
>                 ret = ptrace_setoptions(child, data);
>                 break;
>         case PTRACE_GETEVENTMSG:
> -               ret = put_user(child->ptrace_message, (unsigned long __user *) data);
> +               ret = put_user(child->ptrace_message,
> +                              (unsigned long __user __force *) data);
>                 break;

Maybe you should introduce a new temporary variable

	void __user *p = (void __user __force*)data;

and get rid of all the other casts instead.

	Arnd
