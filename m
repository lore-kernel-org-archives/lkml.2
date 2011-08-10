Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1HJXuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:50:21 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:58890 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085Ab1HJXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:50:19 -0400
Subject: Re: dynamic-debug not built into scx200_acb, scx200_i2c
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
In-Reply-To: <CAJfuBxwq3xw3MZU01rwzg0NAnnxNoLrC2x0QXnj+2pD-6gkR4g@mail.gmail.com>
References: <CAJfuBxwq3xw3MZU01rwzg0NAnnxNoLrC2x0QXnj+2pD-6gkR4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 16:50:16 -0700
Message-ID: <1313020216.11924.129.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 15:06 -0600, Jim Cromie wrote:
> scx200_acb has several pr_debugs, but theyre not available via dynamic-debug
> 
> Ive been unable to figure out why.
> Any ideas ?

-DDEBUG forces pr_debug to be output and doesn't
allow dynamic_debug for those outputs.

from drivers/i2c/busses/Makefile:

ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG

from printk.h:

/* If you are writing a driver, please use dev_dbg instead */
#if defined(DEBUG)
#define pr_debug(fmt, ...) \
	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
#elif defined(CONFIG_DYNAMIC_DEBUG)
/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
#define pr_debug(fmt, ...) \
	dynamic_pr_debug(fmt, ##__VA_ARGS__)



