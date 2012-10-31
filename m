Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2JaR27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:28:59 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:19739 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab2JaR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:28:57 -0400
Date: Wed, 31 Oct 2012 17:28:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] use this_cpu_ptr instead of  per_cpu_ptr(p,
 smp_processor_id())
In-Reply-To: <509109D2.9030209@gmail.com>
Message-ID: <0000013ab7de641e-c975be0c-e85b-4705-8f02-e25b2d4a0ac2-000000@email.amazonses.com>
References: <509109D2.9030209@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> this_cpu_ptr is faster than per_cpu_ptr(p, smp_processor_id()).
> The latter helper needs to find the offset for current cpu,
> and needs more assembler instructions which objdump shows in following.

The code is shorter and that helps but note that the main effect is that
memory accesses are reduced.
