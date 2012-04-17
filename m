Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2DQTzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:55:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45800 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2DQTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:55:52 -0400
Message-ID: <4F8DCAC5.6000706@wwwdotorg.org>
Date: Tue, 17 Apr 2012 13:55:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH v2 2/2] pinctrl: show pin name for pingroups in sysfs
References: <1334646046-467-1-git-send-email-b29396@freescale.com> <1334646046-467-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1334646046-467-2-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 01:00 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Pin name is more useful to users.
...
> @@ -964,10 +984,14 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
>  			seq_printf(s, "%s [ERROR GETTING PINS]\n",
>  				   gname);
>  		else {
> -			seq_printf(s, "group: %s, pins = [ ", gname);
> -			for (i = 0; i < num_pins; i++)
> -				seq_printf(s, "%d ", pins[i]);
> -			seq_puts(s, "]\n");
> +			seq_printf(s, "group: %s\n", gname);
> +			for (i = 0; i < num_pins; i++) {
> +				pname = pin_get_name(pctldev, pins[i]);
> +				if (WARN_ON(!pname))
> +					return -EINVAL;

The main issue I had here was that the loop should continue rather than
erroring out. Still, I suppose this condition "can't" happen, so perhaps
that isn't such a big deal after all. So:

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

> +				seq_printf(s, "pin %d (%s)\n", pins[i], pname);
> +			}
