Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1F3Vzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:55:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:52222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1F3Vze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:55:34 -0400
Subject: Re: [PATCH v3 8/9] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309361388-30163-9-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-9-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 23:54:26 +0200
Message-ID: <1309470866.12449.604.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> +       if (static_branch((&paravirt_steal_rq_enabled))) {
> +               int is_idle;
> +               u64 st;
> +
> +               is_idle = ((rq->curr != rq->idle) ||
> +                               irq_count() != HARDIRQ_OFFSET);

Now that hurt my brain. If the vcpu is idle, why does it want to run?
How can an idle vcpu ever rack up steal time?

Also, what's that HARDIRQ_OFFSET bit about? sorely lacking in
explanation, and the Changelog to this patch is about as bad as the last
one.

> +               __touch_steal_time(is_idle, delta, &st);
> +
> +               steal = st * TICK_NSEC;
> +
> +               delta -= steal;
> +       }
> +#endif 
