Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0HZWsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 18:48:35 -0400
Received: from n4.bullet.mail.gq1.yahoo.com ([67.195.9.84]:34470 "HELO
	n4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752155Ab0HZWsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 18:48:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 167524.95316.bm@omp130.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=lCjyBjpnn6L2YWkLmqXwmOSt0Ur9bc6SedVKlhYREWJeH76XZsK62kICct04n9U9E2Oe7vQmm07Ie927F5lh0VPi9ynQIAgg/lFmhHaQArmut/qsc1Nbf+rulf889E3tfEoDEb2XeGpUOn1gFgqx1TWQkAy9bdPUP+smXUZC15U=;
Message-ID: <60847.98364.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: aM8MYMIVM1lD5ozUG1U6tTo1fPFpAKYtrCF2Nn8.RIzDLEI
 LA6Mr61mq
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 26 Aug 2010 15:48:31 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] gpio: Add driver for Anton GPIO controllers
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20100826212025.GA3366@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 8/26/10, Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> From: Anton Vorontsov <cbouatmailru@gmail.com>
> Subject: Re: [PATCH v2] gpio: Add driver for Anton GPIO controllers
> To: "David Brownell" <david-b@pacbell.net>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Samuel Ortiz" <sameo@linux.intel.com>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, "David Brownell" <dbrownell@users.sourceforge.net>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
> Date: Thursday, August 26, 2010, 2:20 PM
> On Thu, Aug 26, 2010 at 10:57:33AM
> -0700, David Brownell wrote:
> [...]
>  
> You seemed to be fine with meaningless amba-9999
> or dw_abc names, but 

NOT meaningless ... when there's actual IP behind
the controller!  Which, at first, is what I thought
you were talking about.


> Just kiding, of course. basic_mmio.c works for me.

OK, how about resubmitting?  With that name?

Be sure to add a bit of documentation about 
the controller requirements  ... basically that
it has a register from which all values can be
read, and that either that register can be written,
or there's a pair of set-bit/clear-bit registers
affecting that register and the output pins.

Might be worth mentioning how trivial it is to do
that in hardware like CPLDs/FPGAS/etc, which is
why this handles different word sizes/endianness.
and the expectation that in at least some cases
this will be used with roll-your-own ASIC/FPGA
logic in Verilog or VHDL (yes?).

> I also think it makes sense to drop gpio_ prefix,
> as the driver is already in gpio/ directory.

No, keep it; files move around sometimes, and it's
best if that loses no information.

