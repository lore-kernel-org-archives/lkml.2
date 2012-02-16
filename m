Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2BPFZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:25:37 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54208 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750914Ab2BPFZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:25:35 -0500
Message-ID: <1329369930.5082.4.camel@joe2Laptop>
Subject: Re: [PATCH 4/4] PCI: quirk print dev name with duration
From: Joe Perches <joe@perches.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Date: Wed, 15 Feb 2012 21:25:30 -0800
In-Reply-To: <1329369296-4255-5-git-send-email-yinghai@kernel.org>
References: <1329369296-4255-1-git-send-email-yinghai@kernel.org>
	 <1329369296-4255-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 21:14 -0800, Yinghai Lu wrote:
> So could find out which device is involved with the calling
[]
> +++ linux-2.6/drivers/pci/quirks.c
> @@ -2854,14 +2854,15 @@ static void do_one_fixup_debug(void (*fn
>  	ktime_t calltime, delta, rettime;
>  	unsigned long long duration;
>  
> -	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
> +	printk(KERN_DEBUG "calling  %pF @ %i for %s\n",
> +			fn, task_pid_nr(current), dev_name(&dev->dev));

Might be better to use dev_dbg

	dev_dbg(&dev->dev, "calling %pF @ %i\n", fn, task_pid_nr(current));

[]

> -	printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs\n", fn,
> -		duration);
> +	printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs for %s\n",
> +			fn, duration, dev_name(&dev->dev));

	dev_dbg(&dev->dev, "pci fixup %pF returned after %llu usecs\n",
		fn, duration);


