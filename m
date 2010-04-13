Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0DMDv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 23:51:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab0DMDvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 23:51:54 -0400
Date: Mon, 12 Apr 2010 20:49:49 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <abounine@tundra.com>
Cc: torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       thomas.moll@sysgo.com
Subject: Re: [PATCH v3 3/6] RapidIO: Add Port-Write handling for EM
Message-Id: <20100412204949.862b3fab.akpm@linux-foundation.org>
In-Reply-To: <20100406212238.GC26292@amak.tundra.com>
References: <20100406212238.GC26292@amak.tundra.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 17:22:38 -0400 Alexandre Bounine <abounine@tundra.com> wrote:

> 
> From: Alexandre Bounine <alexandre.bounine@idt.com>
> 
> Add RapidIO Port-Write message handling in the context
> of Error Management Extensions Specification Rev.1.3.
>
> ...
>
> +static struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from)
> +{
> +	struct list_head *n;
> +	struct rio_dev *rdev;
> +
> +	WARN_ON(in_interrupt());

The check should be unneeded - lockdep will warn about this.

> +	spin_lock(&rio_global_list_lock);
> +	n = from ? from->global_list.next : rio_devices.next;
> +
> +	while (n && (n != &rio_devices)) {
> +		rdev = rio_dev_g(n);
> +		if (rdev->comp_tag == comp_tag)
> +			goto exit;
> +		n = n->next;
> +	}
> +	rdev = NULL;
> +exit:
> +	spin_unlock(&rio_global_list_lock);
> +	return rdev;
> +}
> +

