Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1IYLim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:38:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52010 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1IYLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:38:40 -0400
Subject: Re: [PATCH 1/5] smp: Introduce a generic on_each_cpu_mask function
From: Sasha Levin <levinsasha928@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
In-Reply-To: <1316940890-24138-2-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-2-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 25 Sep 2011 14:37:52 +0300
Message-ID: <1316950672.3641.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
> +#define on_each_cpu_mask(mask, func, info, wait) \
> +       if (cpumask_test_cpu(0, (mask))) {      \
> +               local_irq_disable();            \
> +               func(info);                     \
		  (func)(info);
> +               local_irq_enable();             \
> +       }
> + 

Maybe it's worth changing it to be so in case someone passes a func ptr
such as 'ptr[0] + 3'.

-- 

Sasha.

