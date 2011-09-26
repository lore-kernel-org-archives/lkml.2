Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1IZIsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:48:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:34927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1IZIsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:48:39 -0400
Subject: Re: [PATCH 1/5] smp: Introduce a generic on_each_cpu_mask function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Date: Mon, 26 Sep 2011 10:48:07 +0200
In-Reply-To: <1316940890-24138-2-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-2-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317026887.9084.68.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
> +#define on_each_cpu_mask(mask, func, info, wait) \
> +       if (cpumask_test_cpu(0, (mask))) {      \
> +               local_irq_disable();            \
> +               func(info);                     \
> +               local_irq_enable();             \
> +       } 

Typically we wrap that in an extra do { } while(0) loop to properly
consume the trailing ;
