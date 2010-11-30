Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0K3Ux6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:53:58 -0500
Received: from claw.goop.org ([74.207.240.146]:58592 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0K3Ux5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:53:57 -0500
Message-ID: <4CF56463.3040109@goop.org>
Date: Tue, 30 Nov 2010 12:53:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 15/18] Xen: Use this_cpu_ops
References: <20101130190707.457099608@linux.com> <20101130190850.002148257@linux.com>
In-Reply-To: <20101130190850.002148257@linux.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 11:07 AM, Christoph Lameter wrote:
>  static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
>  {
> -	struct clock_event_device *evt = &__get_cpu_var(xen_clock_events);
>  	irqreturn_t ret;
>  
>  	ret = IRQ_NONE;
> -	if (evt->event_handler) {
> -		evt->event_handler(evt);
> +	if (__this_cpu_read(xen_clock_events.event_handler)) {
> +		__this_cpu_read(xen_clock_events.event_handler)(evt);

Really?  What code does this generate?  If this is generating two
segment-prefixed reads rather than getting the address and doing normal
reads on it, then I don't think it is an improvement.

The rest looks OK, I guess.  How does it change the generated code?

    J
