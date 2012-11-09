Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab2KIJ0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:26:31 -0500
Received: from smarthost03.mail.zen.net.uk ([212.23.1.3]:34513 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab2KIJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:26:28 -0500
Message-ID: <1352453183.3236.5.camel@linaro1.home>
Subject: Re: [PATCH] ARM: kprobes: use BUG_ON where possible
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Jon Medhurst <tixy@yxit.co.uk>,
        Leif Lindholm <leif.lindholm@arm.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 09 Nov 2012 09:26:23 +0000
In-Reply-To: <1352406191-14303-4-git-send-email-sasha.levin@oracle.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
	 <1352406191-14303-4-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 15:23 -0500, Sasha Levin wrote:
> Just use BUG_ON() instead of constructions such as:
> 
> 	if (...)
> 		BUG()
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) BUG();
> + BUG_ON(e);
> // </smpl>
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

I'm not sure that trivial changes like this are worth it, but equally,
they're not worth having a discussion about, so...

Acked-by: Jon Medhurst <tixy@linaro.org>

> ---
>  arch/arm/kernel/kprobes-test.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
> index 1862d8f..0fb370d 100644
> --- a/arch/arm/kernel/kprobes-test.c
> +++ b/arch/arm/kernel/kprobes-test.c
> @@ -1212,8 +1212,7 @@ static int register_test_probe(struct test_probe *probe)
>  {
>  	int ret;
>  
> -	if (probe->registered)
> -		BUG();
> +	BUG_ON(probe->registered);
>  
>  	ret = register_kprobe(&probe->kprobe);
>  	if (ret >= 0) {


