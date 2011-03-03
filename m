Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab1CCSRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:17:50 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47435 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab1CCSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:17:49 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1299174652.2071.12.camel@dan>
References: <1299174652.2071.12.camel@dan>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 03 Mar 2011 10:17:46 -0800
Message-ID: <1299176266.8493.2369.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 12:50 -0500, Dan Rosenberg wrote:
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4691,7 +4691,7 @@ static const struct file_operations proc_slabinfo_operations = {
> 
>  static int __init slab_proc_init(void)
>  {
> -       proc_create("slabinfo", S_IRUGO, NULL, &proc_slabinfo_operations);
> +       proc_create("slabinfo", S_IRUSR, NULL, &proc_slabinfo_operations);
>         return 0;
>  }
>  module_init(slab_proc_init); 

Please don't.  In reality, it'll just mean that more data collection
things will have to get done as root, and I'll wear my keyboard out more
often sudo'ing.

If you really want this on particularly pedantic systems, why not chmod?

-- Dave

