Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1INSl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:41:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45748 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab1INSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:41:56 -0400
Subject: Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110910164134.GA2442@albatros>
References: <20110910164001.GA2342@albatros>
	 <20110910164134.GA2442@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 11:41:41 -0700
Message-ID: <1316025701.4478.65.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-10 at 20:41 +0400, Vasiliy Kulikov wrote:
> @@ -4584,7 +4584,8 @@ static const struct file_operations proc_slabstats_operations = {
>  
>  static int __init slab_proc_init(void)
>  {
> -       proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
> +       proc_create("slabinfo", S_IWUSR | S_IRUSR, NULL,
> +                   &proc_slabinfo_operations);
>  #ifdef CONFIG_DEBUG_SLAB_LEAK
>         proc_create("slab_allocators", 0, NULL, &proc_sla 

If you respin this, please don't muck with the whitespace.  Otherwise,
I'm fine with this.  Distros are already starting to do this anyway in
userspace.

Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

