Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab1EaWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:25:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56705 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab1EaWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:25:57 -0400
Date: Tue, 31 May 2011 15:24:45 -0700 (PDT)
Message-Id: <20110531.152445.44639723.davem@davemloft.net>
To: cmdkhh@gmail.com
Cc: bp@alien8.de, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ide-cd: Fix another signedness warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306740418-565-1-git-send-email-cmdkhh@gmail.com>
References: <1306740418-565-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 15:24:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Connor Hansen <cmdkhh@gmail.com>
Date: Mon, 30 May 2011 00:26:58 -0700

> One of the legit warnings 'make W=3 drivers/ide/ide-cd.o generates is
> 
> drivers/ide/ide-cd.c: In function ide_cd_queue_pc:
> drivers/ide/ide-cd.c:451:3: warning: conversion to unsigned int from
>       int may change the sign of the result
> 
> timeout is passed as an int, but is declared as an unsigned int in
> struct request in include/linux/blkdev.h
> 
> Signed-off-by: Connor Hansen <cmdkhh@gmail.com>

This is beyond academic and may in fact introduce strange things.

All except one call site passes "0" for the timeout.

And that one call site passes packet_command->timeout from userspace
which is an 'int'.

I'm not applying this.
