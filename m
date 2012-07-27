Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2G0URZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:17:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57698 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2G0URW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <50126D44.7070608@cn.fujitsu.com>
References: <50126B83.3050201@cn.fujitsu.com>
	<50126D44.7070608@cn.fujitsu.com>
Date: Fri, 27 Jul 2012 13:17:20 -0700
X-Google-Sender-Auth: 4a5Xox8K5gbee1KSctyXTU1oT5Q
Message-ID: <CA+8MBbL+G=xqkWU4xGF3_Ra7KoeoHuzL6QYcRiKqtVZoOBfLdQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 05/19] memory-hotplug: check whether memory is
 present or not
From: Tony Luck <tony.luck@intel.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 3:28 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> +static inline int pfns_present(unsigned long pfn, unsigned long nr_pages)
> +{
> +       int i;
> +       for (i = 0; i < nr_pages; i++) {
> +               if (pfn_present(pfn + 1))

Typo? I think you meant "pfn + i"

> +                       continue;
> +               else
> +                       return -EINVAL;
> +       }
> +       return 0;
> +}

-Tony
