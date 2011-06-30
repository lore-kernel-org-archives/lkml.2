Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1F3Vz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:55:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:52252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1F3Vzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:55:55 -0400
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309361388-30163-8-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-8-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 23:54:34 +0200
Message-ID: <1309470874.12449.610.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
> +static inline u64 steal_ticks(u64 steal)
> +{
> +       if (unlikely(steal > NSEC_PER_SEC))
> +               return steal / TICK_NSEC;

That won't compile on a number of 32bit architecture, use div_u64 or
something similar.

> +
> +       return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
> +} 
