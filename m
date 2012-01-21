Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab2AURSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:18:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44956 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab2AURSn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <1327164143.2050.9.camel@joe2Laptop>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
	<1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
	<1327164143.2050.9.camel@joe2Laptop>
Date: Sat, 21 Jan 2012 09:18:43 -0800
Message-ID: <CAEMzQTZ5ASCrrDJ6KSe41=yKL+7ayo_LfkZh3vagcopiGAj1tQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
From: sam hansen <solid.se7en@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These last two should be KERN_CONT
> though the block could be rewritten as
>
>        if (XGIInitNew(pdev))
>                printk(KERN_INFO "XGIfb: XGIInitNew() ... OK\n");
>        else
>                printk(KERN_ERR "XGIfb: XGIInitNew() ... Fail\n");
>
> Emitting any dmesg output like "XGIInitNew() ... OK\n"
> is almost always low value.
>
> Perhaps just emitting on the error case is better:
>        if (!XGIInitNew(pdev))
>                printk(KERN_ERR "XGIfb: XBIInitNew() failed\n");

Cool.  See Re: Dan.  I will fold the printk logic up.

> One other thing.  It would be better to add
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any #include and convert all the
> printks(KERN_<LEVEL> to pr_<level>(
> stripping all the leading XGIfb: too.

I might take a stab at eliminating explicit calls to printk and use a macro.
