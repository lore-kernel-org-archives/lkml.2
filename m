Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840Ab1ACXeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 18:34:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51976 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1ACXeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 18:34:06 -0500
Date: Mon, 3 Jan 2011 15:32:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char nvtty: Network Virtual Terminal support
Message-Id: <20110103153231.ce70dbb5.randy.dunlap@oracle.com>
In-Reply-To: <1294067735-21466-2-git-send-email-giometti@linux.it>
References: <1294067735-21466-1-git-send-email-giometti@linux.it>
	<1294067735-21466-2-git-send-email-giometti@linux.it>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Jan 2011 16:15:35 +0100 Rodolfo Giometti wrote:

> A Network Virtual terminal (NVT tty) is a software device consisting
> of one halves: a client device, which is identical to a physical
> terminal, who, is turn, get connected with a remote server where real
> tty devices are located.
> 
> These devices are specified by RFC 854 and RFC 2217 and ther name into
> the system is /dev/nvttyX (by default you have 4 devices).
> 
> By using these devices and a proper compatible server (not included
> here but you can use sredird) you can get access to a remote tty
> device as the tty device itself was conneted with your local host.
> All data and settings are sent and received through the network.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  Documentation/ABI/testing/sysfs-nvtty |   35 +
>  drivers/char/Kconfig                  |   22 +
>  drivers/char/Makefile                 |    1 +
>  drivers/char/nvtty.c                  | 1557 +++++++++++++++++++++++++++++++++
>  4 files changed, 1615 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-nvtty
>  create mode 100644 drivers/char/nvtty.c
> 

> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 43d3395..13775be 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -451,6 +451,28 @@ config UNIX98_PTYS
>  	  All modern Linux systems use the Unix98 ptys.  Say Y unless
>  	  you're on an embedded system and want to conserve memory.
>  
> +config NVT_TTY
> +	tristate "Network Virtual Terminal"
> +	default m

Don't enable random drivers, please.

> +	---help---
> +	  A Network Virtual terminal (NVT tty) is a software device
> +	  consisting of one halves: a client device, which is

	"one" and "halves" do not go together.

> +	  identical to a physical terminal, who, is turn, get

	                                         in turn, gets

> +	  connected with a remote server where real tty devices are

	            to a remote server

> +	  located.
> +
> +	  These devices are specified by RFC 854 and RFC 2217 and ther

	                                                          the ?? or their ??

> +	  name into the system is /dev/nvttyX (by default you have 4

	                                      (by default there are 4

> +	  devices).
> +
> +	  By using these devices and a proper compatible server (not
> +	  included here but you can use sredird) you can get access to
> +	  a remote tty device as the tty device itself was conneted

	                      as though the tty device itself was connected

> +	  with your local host.  All data and settings are sent and
> +	  received through the network.
> +
> +	  If unsure, say M.
> +
>  config DEVPTS_MULTIPLE_INSTANCES
>  	bool "Support multiple instances of devpts"
>  	depends on UNIX98_PTYS


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
