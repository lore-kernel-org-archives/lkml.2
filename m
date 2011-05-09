Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1EIIYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:24:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54771 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1EIIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:24:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 8/8] proc: allocate storage for numa_maps statistics once
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303947349-3620-9-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca> <1303947349-3620-9-git-send-email-wilsons@start.ca>
Message-Id: <20110509172613.166B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 17:24:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int numa_maps_open(struct inode *inode, struct file *file)
>  {
> -	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
> +	struct numa_maps_private *priv;
> +	int ret = -ENOMEM;
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (priv) {
> +		priv->proc_maps.pid = proc_pid(inode);
> +		ret = seq_open(file, &proc_pid_numa_maps_op);
> +		if (!ret) {
> +			struct seq_file *m = file->private_data;
> +			m->private = priv;
> +		} else {
> +			kfree(priv);
> +		}
> +	}
> +	return ret;
>  }

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




