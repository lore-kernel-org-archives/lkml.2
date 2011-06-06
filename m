Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1FFX0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:26:11 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:52451 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab1FFX0J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:26:09 -0400
From: Kevin Hilman <khilman@ti.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: l-o <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
Organization: Texas Instruments, Inc.
References: <1307214239-16316-1-git-send-email-ccross@android.com>
	<BANLkTingmUNvZO_szivRkmn7LRO4L5A+5Q@mail.gmail.com>
	<87r576wpz6.fsf@ti.com> <20110606230522.GA16590@google.com>
Date: Mon, 06 Jun 2011 16:25:02 -0700
In-Reply-To: <20110606230522.GA16590@google.com> (Todd Poynor's message of
	"Mon, 6 Jun 2011 16:05:22 -0700")
Message-ID: <87y61etuep.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Poynor <toddpoynor@google.com> writes:

> On Mon, Jun 06, 2011 at 03:32:29PM -0700, Kevin Hilman wrote:
>> Colin Cross <ccross@android.com> writes:
>> 
>> > On Sat, Jun 4, 2011 at 12:03 PM, Colin Cross <ccross@android.com> wrote:
>> >> Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
>> >> causing only the last bit set to take effect, resulting in lost
>> >> wakeups when the GPIO controller is in idle.
>> >>
>> >> Replace direct writes to IRQWAKEN with writes to SETWKUENA and
>> >> CLEARWKUEN.
>> >>
>> >> Signed-off-by: Colin Cross <ccross@android.com>
>> 
>> [...]
>> 
>> >
>> > Todd pointed out that the OMAP4 TRM says not to use SETWKUENA and
>> > CLEARWKUENA.  
>> 
>> In my GPIO cleanups, I was wondering why the set/clear registers were
>> not used here. Todd, can you give the TRM version & reference for this?
>> I didn't find anything after a quick scan/search.
>
> http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?templateId=6123&navigationId=12037
>
> OMAP4460 Multimedia Device Silicon Revision 1.0 Version E
> February 2011–Revised May 2011
>
> p. 5357 Table 25-68. GPIO_CLEARWKUPENA
>
> "Caution: This register is kept for backward software compatibility. Use
> GPIO_IRQWAKEN_0 and GPIO_IRQWAKEN_1 instead."

OK, I see it now.

Thanks,

Kevin

