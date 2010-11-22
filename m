Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KVRR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:17:29 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47447 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0KVRR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:17:28 -0500
Subject: Re: [RFC][PATCH] perf: Tracepoint collection support
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        fweisbec <fweisbec@gmail.com>, Stephane Eranian <eranian@google.com>,
        paulus <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1290445737.2072.338.camel@laptop>
References: <1290445737.2072.338.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 18:17:42 +0100
Message-ID: <1290446262.2072.339.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 18:08 +0100, Peter Zijlstra wrote:
> +       if (event->attr.config != ~0ULL) {
> +               err = __perf_event_add_tp(event, event->attr.config);
> +               if (err)
> +                       return err;
> +               err = perf_trace_init(event, event->attr.config);
> +               if (err)
> +                       return err;
> +       } 

That's a double perf_trace_init() call, __perf_event_add_tp() already
does that.
