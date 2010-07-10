Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0GJSwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:52:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44490 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab0GJSwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:52:53 -0400
Message-ID: <4C38C148.2060805@zytor.com>
Date: Sat, 10 Jul 2010 11:51:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC/PATCH] x86: Early-boot serial I/O support
References: <1278785277-22629-1-git-send-email-penberg@cs.helsinki.fi>
In-Reply-To: <1278785277-22629-1-git-send-email-penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 11:07 AM, Pekka Enberg wrote:
> This patch adds serial I/O support to very early boot printf(). It's useful for
> debugging boot code when running Linux under KVM, for example. The actual code
> was lifted from early printk.

Yinghai is correct that this really needs to pick apart the command 
line, especially since there is already support for command-line parsing 
in the early boot code.  I suggest we just reuse the earlyprintk= 
option, especially since it's basically the same code and so should have 
the same failure profile.

> +
> +	while ((inb(early_serial_base + LSR)&  XMTRDY) == 0&&  --timeout)
> +		;
> +

cpu_relax(); here, probably.

	-hpa
