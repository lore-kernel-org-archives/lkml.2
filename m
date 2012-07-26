Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2GZARL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:17:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47247 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2GZARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:17:10 -0400
Date: Wed, 25 Jul 2012 17:17:06 -0700 (PDT)
Message-Id: <20120725.171706.1150592587492146246.davem@davemloft.net>
To: joe@perches.com
Cc: gregkh@linuxfoundation.org, jbaron@redhat.com, kay@vrfy.org,
        jim.cromie@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: Restore dev_dbg/netdev_dbg
 functionality, reduce stack use
From: David Miller <davem@davemloft.net>
In-Reply-To: <403af268697d3d117114b12000b20c74aafa5bac.1343261030.git.joe@perches.com>
References: <403af268697d3d117114b12000b20c74aafa5bac.1343261030.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 25 Jul 2012 17:10:00 -0700

> commit c4e00daaa9 ("driver-core: extend dev_printk() to pass structured data")
> changed __dev_printk and broke dynamic-debug's ability to control the
> dynamic prefix of dev_dbg(dev,..).
> 
> dynamic_emit_prefix() adds "[tid] module:func:line:" to the output and
> those additions got lost.
> 
> In addition, the current dynamic debug code uses up to 3 recursion
> levels via %pV.  This can consume quite a bit of stack.  Directly
> call printk_emit to reduce the recursion by one depth.
> 
> These changes include:
> 
> o Remove KERN_DEBUG from dynamic_emit_prefix
> o Create and use function create_syslog_header to format the syslog
>   header for printk_emit uses.
> o Call create_syslog_header and neaten __dev_printk
> o Call create_syslog_header and printk_emit from dynamic_dev_dbg
> o Call create_syslog_header and printk_emit from dynamic_netdev_dbg
> o Make __dev_printk and __netdev_printk static not global
> o Remove include header declarations of __dev_printk and __netdev_printk
> o Remove now unused EXPORT_SYMBOL()s of __dev_printk and __netdev_printk
> o Whitespace neatening
> 
> Signed-off-by: Joe Perches <joe@perches.com>

For networking parts:

Acked-by: David S. Miller <davem@davemloft.net>
