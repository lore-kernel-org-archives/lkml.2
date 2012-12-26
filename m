Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2LZT1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 14:27:25 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36092 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2LZT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 14:27:22 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <1356549008.20133.20856.camel@edumazet-glaptop>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org>  <50D52E0C.6000103@redhat.com>
	 <1356549008.20133.20856.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Dec 2012 11:27:19 -0800
Message-ID: <1356550039.20133.20884.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-26 at 11:10 -0800, Eric Dumazet wrote:

> +#define DELAY_HASH_SHIFT 4
> +DEFINE_PER_CPU(int [1 << DELAY_HASH_SHIFT], spinlock_delay) = { 
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +	MIN_SPINLOCK_DELAY, MIN_SPINLOCK_DELAY,
> +};

This can use the following initialize by the way :

DEFINE_PER_CPU(int [1 << DELAY_HASH_SHIFT], spinlock_delay) = {
        [0 ... (1 << DELAY_HASH_SHIFT) - 1] = MIN_SPINLOCK_DELAY,
};



