Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0CWHbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 03:31:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56965 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0CWHbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 03:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZEFVVF0i9xfQH86AOy4HzWsSynbeeUw3tJWHDBS5bGct9CuHMRuB1BDxF1FQKqoD40
         DcIfHBgr0SoHww2NFoRCu5QQQmT+11g4MuEzNGdlI9yc4sGQv58ZZjzB5KQ0iW89jiHD
         0F5okcCuJSJztcwDfSlNV7VaABN4mEFQXbSM0=
Date: Tue, 23 Mar 2010 00:31:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (input
 tree related)
Message-ID: <20100323073110.GA2157@core.coreip.homeip.net>
References: <20100323175456.e01dd822.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323175456.e01dd822.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 05:54:56PM +1100, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> drivers/built-in.o: In function `sysrq_filter':
> sysrq.c:(.text+0x224da): undefined reference to `fg_console'
> sysrq.c:(.text+0x224e2): undefined reference to `fg_console'
> sysrq.c:(.text+0x224f2): undefined reference to `vc_cons'
> sysrq.c:(.text+0x224f6): undefined reference to `vc_cons'
> drivers/built-in.o: In function `sysrq_disconnect':
> sysrq.c:(.text+0x226e4): undefined reference to `input_close_device'
> sysrq.c:(.text+0x226ec): undefined reference to `input_unregister_handle'
> drivers/built-in.o: In function `sysrq_connect':
> sysrq.c:(.text+0x22780): undefined reference to `input_register_handle'
> sysrq.c:(.text+0x22790): undefined reference to `input_open_device'
> sysrq.c:(.text+0x227f0): undefined reference to `input_unregister_handle'
> drivers/built-in.o: In function `sysrq_toggle_support':
> (.text+0x22b6c): undefined reference to `input_unregister_handler'
> drivers/built-in.o: In function `sysrq_toggle_support':
> (.text+0x22bac): undefined reference to `input_register_handler'
> drivers/built-in.o: In function `sysrq_init':
> sysrq.c:(.init.text+0x18d4): undefined reference to `input_register_handler'
> 
> Caused by commit edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("Input:
> implement SysRq as a separate input handler").  This build does not have
> CONFIG_HW_CONSOLE or CONFIG_INPUT set, but does have CONFIG_MAGIC_SYSRQ
> set to 'y'.
>

Sorry about this, I did not expect Sysrq being available without input.
I will try to fix up the tree in time for your tomorrow fetch.


-- 
Dmitry
