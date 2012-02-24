Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2BXDkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:40:04 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:18867
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026Ab2BXDkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:40:02 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 24 Feb 2012 11:47:26 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] pinctrl: Move pinctrl-maps debugfs file to
 top-level
Message-ID: <20120224034725.GC25789@shlinux2.ap.freescale.net>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
 <1330041880-12406-3-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330041880-12406-3-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 05:04:40PM -0700, Stephen Warren wrote:
> The debugfs file pinctrl-maps is a system-wide file, not specific to any
> pin controller, so place it in the top-level directory.
> 
Reasonable to me.

> Also, move the code implementing the file to keep the order of all the
> functions matching the order they're created in pinctrl_init_*debugfs().
> The only non-obvious change here is no private data is passed to
> debugfs_create_file() or single_open().
Looks correct.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/pinctrl/core.c |   70 ++++++++++++++++++++++++------------------------
>  1 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 633b97e..376cede 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -889,28 +889,6 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
>  	return 0;
>  }
>  
> -static int pinctrl_maps_show(struct seq_file *s, void *what)
> -{
> -	struct pinctrl_maps *maps_node;
> -	int i;
> -	struct pinctrl_map const *map;
> -
> -	seq_puts(s, "Pinctrl maps:\n");
> -
> -	mutex_lock(&pinctrl_maps_mutex);
> -	for_each_maps(maps_node, i, map) {
> -		seq_printf(s, "%s:\n", map->name);
> -		seq_printf(s, "  device: %s\n", map->dev_name);
> -		seq_printf(s, "  controlling device %s\n", map->ctrl_dev_name);
> -		seq_printf(s, "  function: %s\n", map->function);
> -		seq_printf(s, "  group: %s\n", map->group ? map->group :
> -			   "(default)");
> -	}
> -	mutex_unlock(&pinctrl_maps_mutex);
> -
> -	return 0;
> -}
> -
>  static int pinmux_hogs_show(struct seq_file *s, void *what)
>  {
>  	struct pinctrl_dev *pctldev = s->private;
> @@ -947,6 +925,28 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
>  	return 0;
>  }
>  
> +static int pinctrl_maps_show(struct seq_file *s, void *what)
> +{
> +	struct pinctrl_maps *maps_node;
> +	int i;
> +	struct pinctrl_map const *map;
> +
> +	seq_puts(s, "Pinctrl maps:\n");
> +
> +	mutex_lock(&pinctrl_maps_mutex);
> +	for_each_maps(maps_node, i, map) {
> +		seq_printf(s, "%s:\n", map->name);
> +		seq_printf(s, "  device: %s\n", map->dev_name);
> +		seq_printf(s, "  controlling device %s\n", map->ctrl_dev_name);
> +		seq_printf(s, "  function: %s\n", map->function);
> +		seq_printf(s, "  group: %s\n", map->group ? map->group :
> +			   "(default)");
> +	}
> +	mutex_unlock(&pinctrl_maps_mutex);
> +
> +	return 0;
> +}
> +
>  static int pinctrl_show(struct seq_file *s, void *what)
>  {
>  	struct pinctrl *p;
> @@ -988,11 +988,6 @@ static int pinctrl_gpioranges_open(struct inode *inode, struct file *file)
>  	return single_open(file, pinctrl_gpioranges_show, inode->i_private);
>  }
>  
> -static int pinctrl_maps_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, pinctrl_maps_show, inode->i_private);
> -}
> -
>  static int pinmux_hogs_open(struct inode *inode, struct file *file)
>  {
>  	return single_open(file, pinmux_hogs_show, inode->i_private);
> @@ -1003,6 +998,11 @@ static int pinctrl_devices_open(struct inode *inode, struct file *file)
>  	return single_open(file, pinctrl_devices_show, NULL);
>  }
>  
> +static int pinctrl_maps_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pinctrl_maps_show, NULL);
> +}
> +
>  static int pinctrl_open(struct inode *inode, struct file *file)
>  {
>  	return single_open(file, pinctrl_show, NULL);
> @@ -1029,22 +1029,22 @@ static const struct file_operations pinctrl_gpioranges_ops = {
>  	.release	= single_release,
>  };
>  
> -static const struct file_operations pinctrl_maps_ops = {
> -	.open		= pinctrl_maps_open,
> +static const struct file_operations pinmux_hogs_ops = {
> +	.open		= pinmux_hogs_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
>  	.release	= single_release,
>  };
>  
> -static const struct file_operations pinmux_hogs_ops = {
> -	.open		= pinmux_hogs_open,
> +static const struct file_operations pinctrl_devices_ops = {
> +	.open		= pinctrl_devices_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
>  	.release	= single_release,
>  };
>  
> -static const struct file_operations pinctrl_devices_ops = {
> -	.open		= pinctrl_devices_open,
> +static const struct file_operations pinctrl_maps_ops = {
> +	.open		= pinctrl_maps_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
>  	.release	= single_release,
> @@ -1078,8 +1078,6 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
>  			    device_root, pctldev, &pinctrl_groups_ops);
>  	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
>  			    device_root, pctldev, &pinctrl_gpioranges_ops);
> -	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
> -			    device_root, pctldev, &pinctrl_maps_ops);
>  	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
>  			    device_root, pctldev, &pinmux_hogs_ops);
>  	pinmux_init_device_debugfs(device_root, pctldev);
> @@ -1102,6 +1100,8 @@ static void pinctrl_init_debugfs(void)
>  
>  	debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
>  			    debugfs_root, NULL, &pinctrl_devices_ops);
> +	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
> +			    debugfs_root, NULL, &pinctrl_maps_ops);
>  	debugfs_create_file("pinctrl-handles", S_IFREG | S_IRUGO,
>  			    debugfs_root, NULL, &pinctrl_ops);
>  }
> -- 
> 1.7.0.4
> 
> 

