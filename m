Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2LVD3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:29:48 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51820 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LVD3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:29:45 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20121221185613.1f4c9523@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Dec 2012 19:29:42 -0800
Message-ID: <1356146982.21834.8321.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 18:56 -0500, Rik van Riel wrote:
> +	int *delay_ptr = &per_cpu(spinlock_delay, smp_processor_id());
> +	int delay = *delay_ptr;

int delay = __this_cpu_read(spinlock_delay);

>  	}
> +	*delay_ptr = delay;

__this_cpu_write(spinlock_delay, delay);


