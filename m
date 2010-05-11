Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0EKAFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:05:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33394 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0EKAFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:05:08 -0400
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to
 clocksource_register_hz
From: john stultz <johnstul@us.ibm.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
	 <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 17:04:56 -0700
Message-ID: <1273536296.3843.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:33 -0400, Jim Cromie wrote:
> On Fri, Apr 30, 2010 at 9:36 PM, John Stultz <johnstul@us.ibm.com> wrote:
> hi John,
> 
> On casual inspection, this looks good, however
> I wont be able to try it on the hardware til early June earliest.
> 
> I have a few qs, (idle musings really)
> 
> - scx200_hrt cannot be rmmod'd, due iirc to the clocksource design.
> This is not a problem, but I wonder if it might be added later, and what
> it might mean to the drivers (in a new module_exit())


I've not really heard much of a compelling argument for clocksource
driver removal, nor has anyone wanted to put much effort there so far.
That said, I'm not opposed to it right off.  It just not a priority.


> - HRT_SHIFT_1/_27 macros are removed, and now calculated in clocksource code.
> I chose a 1:16 shift ratio for the 1:27 input clocks.  I suppose I could have
> used 1:32, I dont recall thinking of it or trying it then.
> What would/should your new code do ?

I'm not sure I'm following what you mean with the ratios, but the new
code will select the largest shift value possible, where the resulting
mult won't overflow 64bits when multiplied against 5 seconds (that
interval length may be changed in the future) worth of cycles.


> - when writing scx200_hrt, I chose to adjust by ppm, not +/- hz
> partly cuz it was easier to describe in a 1-line mod-desc, and partly
> cuz 1/27ppm vernier-knob is overkill on a $0.25 crystal.
> The new API name (with _hz suffix) suggests that I could change
> the mod-param-name, and add it in after the 1:27 multiplier.

I believe its still mathematically identical to what you had before, but
let me know if I'm mistaken here.

thanks
-john


