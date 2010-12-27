Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0L0AtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 19:49:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33550 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0L0AtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:49:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jx7XNJ5lJ+ySDkYvxejvWSB5rThzhZhebr+fJXat5+YNnyDFNpz/3Ap1Q5lFnNYyGM
         LzgN0HmQrDdg0U1M+cjci7jiVfLtIADvHmPY0obZHwfNvTeQa+C5Snb4HkKDFimc3gX2
         FaALOpuLc5IoF4lQZD6QHtj5vaXPQPC2TXnN4=
Message-ID: <4D17E289.2040505@garzik.org>
Date: Sun, 26 Dec 2010 19:49:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>,
        Zhang Le <r0bertz@gentoo.org>, Chen Jie <chenj@lemote.com>
Subject: Re: linux-next: build warning after merge of the Linus' tree
References: <20101227095812.0f727881.sfr@canb.auug.org.au>
In-Reply-To: <20101227095812.0f727881.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2010 05:58 PM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the Linus' tree, today's linux-next build (x86_64 allmodconfig)
> produced these warnings:
>
> drivers/ata/pata_cs5536.c:47:1: warning: "rdmsr" redefined
> In file included from arch/x86/include/asm/irqflags.h:60,
>                   from include/linux/irqflags.h:15,
>                   from arch/x86/include/asm/system.h:11,
>                   from arch/x86/include/asm/processor.h:17,
>                   from include/linux/prefetch.h:14,
>                   from include/linux/list.h:7,
>                   from include/linux/module.h:9,
>                   from drivers/ata/pata_cs5536.c:33:
> arch/x86/include/asm/paravirt.h:146:1: warning: this is the location of the previous definition
> drivers/ata/pata_cs5536.c:48:1: warning: "wrmsr" redefined
> arch/x86/include/asm/paravirt.h:154:1: warning: this is the location of the previous definition
>
> Caused by commit 9272dcc232b84ccb027d6861077934055d42764d ("pata_cs5536:
> Add support for non-X86_32 platforms").

Just sent a fix upstream.

The fix is a bit ugly ("#undef rdmsr" etc.), but that driver does not 
need anything more extensive.

