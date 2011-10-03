Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab1JCSYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:24:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34202 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab1JCSY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:24:29 -0400
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        gregkh@suse.de, devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
In-Reply-To: <4E89F6D1.6000502@vflare.org>
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
	 <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org>
	 <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org>
	 <4E72284B.2040907@linux.vnet.ibm.com>
	 <075c4e4c-a22d-47d1-ae98-31839df6e722@default 4E725109.3010609@linux.vnet.ibm.com>
	 <863f8de5-a8e5-427d-a329-e69a5402f88a@default>
	 <1317657556.16137.696.camel@nimitz>  <4E89F6D1.6000502@vflare.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 11:22:34 -0700
Message-ID: <1317666154.16137.727.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 13:54 -0400, Nitin Gupta wrote:
> I think disabling preemption on the local CPU is the cheapest we can get
> to protect PCPU buffers. We may experiment with, say, multiple buffers
> per CPU, so we end up disabling preemption only in highly improbable
> case of getting preempted just too many times exactly within critical
> section.

I guess the problem is two-fold: preempt_disable() and
local_irq_save().  

> static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
>                                 uint32_t index, struct page *page)
> {
>         struct tmem_pool *pool;
>         int ret = -1;
> 
>         BUG_ON(!irqs_disabled());

That tells me "zcache" doesn't work with interrupts on.  It seems like
awfully high-level code to have interrupts disabled.  The core page
allocator has some irq-disabling spinlock calls, but that's only really
because it has to be able to service page allocations from interrupts.
What's the high-level reason for zcache?

I'll save the discussion about preempt for when Seth posts his patch.

-- Dave

