Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1BUJ7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:59:11 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:24658 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1BUJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:59:10 -0500
Date: Mon, 21 Feb 2011 10:58:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the i2c tree
Message-ID: <20110221105858.197cbf1d@endymion.delvare>
In-Reply-To: <20110221153522.8a0b29bf.sfr@canb.auug.org.au>
References: <20110221153522.8a0b29bf.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 21 Feb 2011 15:35:22 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> drivers/i2c/i2c-core.c: In function 'i2c_do_add_adapter':
> drivers/i2c/i2c-core.c:799: warning: 'attach_adapter' is deprecated (declared at include/linux/i2c.h:149)
> drivers/i2c/i2c-core.c:804: warning: 'attach_adapter' is deprecated (declared at include/linux/i2c.h:149)
> drivers/i2c/i2c-core.c: In function 'i2c_do_del_adapter':
> drivers/i2c/i2c-core.c:985: warning: 'detach_adapter' is deprecated (declared at include/linux/i2c.h:150)
> drivers/i2c/i2c-core.c:988: warning: 'detach_adapter' is deprecated (declared at include/linux/i2c.h:150)
> 
> Introduced by commit 95529c656b97b08c7a92504f98650a229f03ae04 ("i2c:
> Deprecate i2c_driver.attach_adapter and .detach_adapter").  We normally
> fix up as many uses of an interface as possible before deprecating it ...

These are the core locations where the deprecated callbacks are called.
Ideally they would _not_ emit warnings, are these are legitimate and
can't be removed before all drivers relying on these callbacks have
been fixed. If there is a way to silent these warnings, please let me
know, as I don't know of any.

-- 
Jean Delvare
