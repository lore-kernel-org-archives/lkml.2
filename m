Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1IUSV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:21:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35394 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1IUSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:21:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=sS35ZZVDr9086CE/xV2MT58S6596Z1nzkrl/7bqodCtQDxahTD6ZiLQfq20TV6SYq
	crccHDWOxjrwGRvdjswZA==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1109211053430.2723@ionos>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-2-git-send-email-vnagarnaik@google.com> <alpine.LFD.2.02.1109211053430.2723@ionos>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 21 Sep 2011 11:20:51 -0700
Message-ID: <CAL26m8JH7CyEdYUXtiC8fOmtSzeteFez2h-aWqJu06Lo77npAQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace,x86: Add tracepoint to x86 timer interrupt handler
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 2:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 29 Jul 2011, Vaibhav Nagarnaik wrote:
>
>> The x86 timer interrupt handler is the only handler not traced in the
>> irq/irq_handler_{entry|exit} trace events.
>
> Nonsense. The timer irq (irq0) comes via the genirq interrupt handling
> and not via a special vector. So it's traced already.
>

Thanks for pointing it out, I confused the PIT/HPET for the local timer
vector.

Could you also take a look at the patches that add tracing for traps?
https://lkml.org/lkml/2011/5/3/455
https://lkml.org/lkml/2011/5/3/456



Vaibhav Nagarnaik
