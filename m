Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0JVRiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:38:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab0JVRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:38:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma/coh901318: fix copy_to_user error path
Date: Fri, 22 Oct 2010 19:38:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: Nicolas Kaiser <nikai@nikai.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Per Friden <per.friden@stericsson.com>, linux-kernel@vger.kernel.org
References: <20101022192953.1f67b10a@absol.kitzblitz>
In-Reply-To: <20101022192953.1f67b10a@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221938.12591.arnd@arndb.de>
X-Provags-ID: V02:K0:p6pVBDr4vSvnYmT1cWrmzhSg6PoGxrek8XVQC5Nftmp
 5Wtt01N5gB9OwpqNvQ0v/Kw7x1j0bjsJP9wFwC8t3IaY9utcxe
 nT3W6+k1rv2ih0kfBT7NR3797CLZX0kjtI9hRrUqZybU2j4exZ
 Z5bDLjYMQOVSyWFWAaghtgGRZA1qqPWnzho6biL6Ps0g37IMFw
 1qjCRZBPWxZX/VzmHn5bQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 19:29:53 Nicolas Kaiser wrote:
> If copy_to_user fails, the assigned error code instantly gets
> overwritten, and the failure apparently ignored. Moreover,
> shouldn't the error code be -EFAULT instead of -EINVAL?

Looks good, but it would be even better to just use
simple_read_from_buffer in this function, which takes care of
a lot the other complexities as well.

	Arnd
