Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab0HSFTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:19:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42019 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0HSFT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M3lhTmTx/6Yuq2eIYWtpyzLMR07elRJjEN3hEImUMdmgHqLYTPPZzPv1Taz42y3btn
         nAwsiuXsCUR+Y3pC/KV/WrX29bxD5ItIed4uZCOE57JrXT9+MMA2s27kW+0D5VFxiKku
         hjIuCPZ/Jf9h7uZi2IRmANAC6VAzkdPqEoMnw=
Date: Wed, 18 Aug 2010 22:19:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: linux-next: build failure after merge of the input tree
Message-ID: <20100819051919.GA5832@core.coreip.homeip.net>
References: <20100819113545.ee9d52ec.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819113545.ee9d52ec.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Aug 19, 2010 at 11:35:45AM +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> After merging the input tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/usb/serial/ssu100.c:599: warning: passing argument 1 of 'usb_serial_handle_sysrq_char' from incompatible pointer type
> include/linux/usb/serial.h:345: note: expected 'struct usb_serial_port *' but argument is of type 'struct tty_struct *'
> drivers/usb/serial/ssu100.c:599: warning: passing argument 2 of 'usb_serial_handle_sysrq_char' makes integer from pointer without a cast
> include/linux/usb/serial.h:345: note: expected 'unsigned int' but argument is of type 'struct usb_serial_port *'
> drivers/usb/serial/ssu100.c:599: error: too many arguments to function 'usb_serial_handle_sysrq_char'
> 
> Caused by commit 0c870dc9828fee03abd60b441f9025a1b4e3d3e6 ("USB: drop tty
> argument from usb_serial_handle_sysrq_char()") interacting with
> 52af954599396e5945a895035525c703f2761b20 ("USB: add USB serial ssu100
> driver") from Linus' tree.
> 
> I have used the input tree from next-20100818 for today.

I updated the patch in question to include this new driver as well,
thank you for letting me know.

-- 
Dmitry
