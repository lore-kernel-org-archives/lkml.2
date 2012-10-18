Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2JRKpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:45:19 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:7507 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab2JRKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:45:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15251209"
Message-ID: <1350557077.2460.113.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V3 2/6]: PVH: use native irq, enable
 callback, use HVM ring ops, smp, ...
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 11:44:37 +0100
In-Reply-To: <20121017173005.73a03eec@mantra.us.oracle.com>
References: <20121017173005.73a03eec@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 01:30 +0100, Mukesh Rathor wrote:
> PVH: make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz}, PVH
> only needs to send down gdtaddr and gdtsz. irq.c: PVH uses
> native_irq_ops. vcpu hotplug is currently not available for PVH.
> events.c: setup callback vector for PVH. smp.c: This pertains to
> bringing up smp vcpus. PVH runs in ring 0, so syscalls are native.
> Also, the vcpu context is send down via the hcall to be set in the
> vmcs. gdtaddr and gdtsz are unionionized as PVH only needs to send
> these two to be set in the vmcs. Finally, PVH ring ops uses HVM paths
> for xenbus.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/include/asm/xen/interface.h |   11 +++++-
>  arch/x86/xen/irq.c                   |    5 ++-
>  arch/x86/xen/p2m.c                   |    2 +-
>  arch/x86/xen/smp.c                   |   75
> ++++++++++++++++++++++------------ drivers/xen/cpu_hotplug.c
> |    4 +- drivers/xen/events.c                 |    9 ++++-
>  drivers/xen/xenbus/xenbus_client.c   |    3 +-

This patch seems to have been horribly whitespace damaged.

Have you seen "git send-email" ? It's very useful for avoiding this sort
of thing and also takes a lot of the grunt work out of reposting a
series.

It also chains the patches as replies to the introductory zero-th mail
-- which is something I've been meaning to ask you to do for a while.
It's useful because it joins the series together in a thread which makes
it easier to keep track of in my INBOX.

Ian.

