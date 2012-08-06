Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2HFNjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:39:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2HFNjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:39:22 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=wom5GMh1gUkA:10 a=KbFfvDdchhsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=ag1SF4gXAAAA:8 a=NBU7XEemx35zZSvxvcwA:9 a=CjuIK1q_8ugA:10 a=1TSTQ8KKaH4A:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Date: Mon, 6 Aug 2012 09:39:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andi Kleen <andi@firstfloor.org>, kay@vrfy.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
Message-ID: <20120806133917.GF16873@home.goodmis.org>
References: <m2628z6euk.fsf@firstfloor.org>
 <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
 <20120803200822.GC731@harshnoise.musicnaut.iki.fi>
 <CAFm5wm2sf9LnZNj9_BDYTF9G7XH32fOL3x5n=kZ-1ih0Cek2DQ@mail.gmail.com>
 <20120803215954.GA4489@kroah.com>
 <CAFm5wm1_-JP0xjDdBvAcqqpZPQvxJPsmNtUOFQyaNw=6H_JJcg@mail.gmail.com>
 <20120803221327.GA5102@kroah.com>
 <CAFm5wm3ayofPD7oF1=z_jwE_wuqBxBHicAs=KOhjcUr7Jo0wDQ@mail.gmail.com>
 <20120803223623.GB6156@kroah.com>
 <CAFm5wm1SSmbdi09hc1Qo1eHw5Tc0vbMf1hWuNw-cjZEEx3jX5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFm5wm1SSmbdi09hc1Qo1eHw5Tc0vbMf1hWuNw-cjZEEx3jX5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 03:48:26PM -0700, Pandita, Vikram wrote:
> On Fri, Aug 3, 2012 at 3:36 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Aug 03, 2012 at 03:25:17PM -0700, Pandita, Vikram wrote:
> >> >> This was something that got used internally and helped at times.
> >> >
> >> > Could you have used the trace point instead?
> >>
> >> As i understood the trace_prink(), one would need to modify existing
> >> printk -> trace_printk. Is my understanding correct?
> >
> > No, you should just be able to watch the tracepoint, right?
> 
> yes.
> Assumption being you know _EXACTLY_ what code piece to watch for.
> Which may not be the case all times.

But it traces all printks.

 # echo 1 > /sys/kernel/debug/tracing/events/printk/console/enable
 # mount /home/rostedt
 # cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        modprobe-2707  [002] d..1    97.079458: console: [   95.816945] NFS: Registering the id_resolver key type

        modprobe-2707  [002] d..1    97.084534: console: [   95.822038] Key type id_resolver registered

If you wanted this from boot up, you can just add to the kernel command line:

  trace_event=console

-- Steve

