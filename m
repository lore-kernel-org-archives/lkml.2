Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2HaUzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:55:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HaUzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:55:16 -0400
Date: Fri, 31 Aug 2012 13:55:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: wency@cn.fujitsu.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC v8 PATCH 04/20] memory-hotplug: offline and remove memory
 when removing the memory device
Message-Id: <20120831135514.2a2dc0d4.akpm@linux-foundation.org>
In-Reply-To: <1346148027-24468-5-git-send-email-wency@cn.fujitsu.com>
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>
	<1346148027-24468-5-git-send-email-wency@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012 18:00:11 +0800
wency@cn.fujitsu.com wrote:

> +int remove_memory(int nid, u64 start, u64 size)
> +{
> +	int ret = -EBUSY;
> +	lock_memory_hotplug();
> +	/*
> +	 * The memory might become online by other task, even if you offine it.
> +	 * So we check whether the cpu has been onlined or not.

I think you meant "memory", not "cpu".

Actually, "check whether any part of this memory range has been
onlined" would be better.  If that is accurate ;)

> +	 */
> +	if (!is_memblk_offline(start, size)) {
> +		pr_warn("memory removing [mem %#010llx-%#010llx] failed, "
> +			"because the memmory range is online\n",
> +			start, start + size);
> +		ret = -EAGAIN;
> +	}
> +
> +	unlock_memory_hotplug();
> +	return ret;
> +
> +}
> +EXPORT_SYMBOL_GPL(remove_memory);
