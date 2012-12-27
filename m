Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2L0O1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:27:34 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:35954 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2L0O1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:27:32 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
	 <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com>
	 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Dec 2012 06:27:28 -0800
Message-ID: <1356618448.30414.948.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-26 at 22:07 -0800, Michel Lespinasse wrote:

> If we go with per-spinlock tunings, I feel we'll most likely want to
> add an associative cache in order to avoid the 1/16 chance (~6%) of
> getting 595Mbit/s instead of 982Mbit/s when there is a hash collision.
> 
> I would still prefer if we could make up something that didn't require
> per-spinlock tunings, but it's not clear if that'll work. At least we
> now know of a simple enough workload to figure it out :)

Even with a per spinlock tuning, we can find workloads where holding
time depends on the context.

For example, complex qdisc hierarchy typically use different times on
enqueue and dequeue operations.

So the hash sounds good to me, because the hash key could mix both lock
address and caller IP ( __builtin_return_address(1) in
ticket_spin_lock_wait())





