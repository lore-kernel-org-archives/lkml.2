Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab2LVATF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 19:19:05 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46334 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2LVATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 19:19:03 -0500
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
Date: Fri, 21 Dec 2012 16:18:56 -0800
Message-ID: <1356135536.21834.8114.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 18:56 -0500, Rik van Riel wrote:
> Argh, the first one had a typo in it that did not influence
> performance with fewer threads running, but that made things
> worse with more than a dozen threads...

> +
> +		/*
> +		 * The lock is still busy, the delay was not long enough.
> +		 * Going through here 2.7 times will, on average, cancel
> +		 * out the decrement above. Using a non-integer number
> +		 * gets rid of performance artifacts and reduces oversleeping.
> +		 */
> +		if (delay < MAX_SPINLOCK_DELAY &&
> +				((inc.head & 3) == 0 || (inc.head & 7) == 1))
> +			delay++;

((inc.head & 3) == 0 || (inc.head & 7) == 1)) seems a strange condition
to me...


