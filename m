Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1GFVus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:50:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1GFVuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:50:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ARCcD/do5NNtRpDv2R3UE/XpKvOfl4f5QjawgZvKmPKca+hX6MKixHUjFImPjnr6p
	AgzNa/udy8SO5rmvFNvAg==
MIME-Version: 1.0
In-Reply-To: <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com> <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 6 Jul 2011 14:50:11 -0700
Message-ID: <CAL26m8KYPCoJzRVsVXCmEAqXKiaRGZu840potVD+83JR27tfCg@mail.gmail.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 11:45 AM, Vaibhav Nagarnaik
<vnagarnaik@google.com> wrote:
> From: Jiaying Zhang <jiayingz@google.com>
>
> The current interrupt trace of irq_handler_entry and irq_handler_exit
> give traces of when an interrupt is handled. They provide good data
> about when the system is running in kernel space and how it affects the
> currently running applications.
>
> Apart from this, they are IRQ vectors which trigger the system into
> kernel space. Tracing such events gives us the trace of where the system
> is spending its time. We want to know which cores are handling
> interrupts and how they are affecting other processes in the system.
> Also, the trace provides information about when the cores are idle and
> which interrupts are changing that state.
>
> The following patch adds the event definition and trace instrumentation
> for interrupt vectors. A lookup table is provided to print out readable
> IRQ vector names. Apart from the IRQ vectors handled in the generic
> kernel code, some x86 specific IRQ vectors are also traced. The lookup
> table can be extended by adding other arch-specific IRQ vectors.
>
> Changelog:
> v2-v3
> * Move the irq_vector_{entry|exit} tracepoints back under irq/ sub
>  folder
> * Trace the common IRQs in generic kernel code so that all archs can
>  benefit.
>
> v1-v2
> * Move the irq_vector_{entry|exit} tracepoints under irq_vectors/ sub
>  folder
>
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

Hi All

Can you please take a look at this patch? Does it cover all the generic
IRQ handlers so they are traced?



Thanks

Vaibhav Nagarnaik
