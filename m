Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758Ab2CSN4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:56:10 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:26276 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756748Ab2CSN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:56:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _nihuGgVM1ncoHg8nPWtp_83mBWMklKgMEqUMUAVu5TzHn0
 y1PgQ7johovi1A3_u5c8mEtV62JpOop6Vbq9XWDrKF7jSp1K3YL5SmXDZ71m
 Wa2NFN_t98tZiJdLZB0r.50daOrjh4lATX39F7Aw1GHo8HZXhexaRRD_aKwG
 wCRyg8taC0zqmYmEmPTFKHrU8gMbcWdBCx8k1PFbAMi6vZBgnbI69EWuFfEi
 2gNk.cyGJe0OPGl5dy7ZRgXeuk.tdfkPGUmqc4pQdOqpwLCLrR6WpQfrYJVZ
 oyIR_4isNNDaFIh05di7WVV6pLF0FDzgRNfiAWn6eKCY5miWrcWVfRObqkQI
 wuNShn7fIsuFB3PesmyllwbWgPRf8rjpu5JDc9A3nQ_cS1TsLpUVwwG3JveZ
 8jizBmQ2qwAeBEvOAgQPL9LHQLtl4Q_Ndj.wtE8kiGYkEK0qWPisbQi6f6gs
 cDPXE6n7XTGlf
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 08:56:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Sasha Levin <levinsasha928@gmail.com>, kaber@trash.net,
        davem@davemloft.net, Dave Jones <davej@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: netfilter: Hung task
In-Reply-To: <20120319002811.GA30408@1984>
Message-ID: <alpine.DEB.2.00.1203190854560.16879@router.home>
References: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com> <20120318141943.GA28850@1984> <CA+1xoqcQYqCgQb=1M5PVkm=6SBhV2oJxJ2CtBp=gAvZM36Kc2Q@mail.gmail.com> <20120319002811.GA30408@1984>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Pablo Neira Ayuso wrote:

> On Sun, Mar 18, 2012 at 10:52:55PM +0200, Sasha Levin wrote:
> > On Sun, Mar 18, 2012 at 4:19 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sun, Mar 18, 2012 at 12:55:13PM +0200, Sasha Levin wrote:
> > >> Hi all,
> > >>
> > >> I got the following spew after fuzzing using trinity on a KVM tools
> > >> guest, using the latest linux-next.
> > >>
> > >> It reminds me a lot of https://lkml.org/lkml/2012/3/14/375 and
> > >> https://lkml.org/lkml/2012/1/14/45
> > >
> > > You mention neither Linux kernel version nor the way you trigger this.
> > >
> > > With that little information it's really hard to really know.
> >
> > Hum? I've mentioned it happened with "the latest linux-next" (which is
> > currently two days old), and using the trinity fuzzer - which means
> > that I don't have a specific method to reproduce the problem.
>
> Sorry, I should not read my email diagonally, really.
>
> Looking at the trace, I'd point to some problem in the slub memory
> allocator. Please, correct me if I'm wrong.
>
> Christoph?


This is sually something causing memory corruption. Please enable
debugging to get backtrace that help to debutg this. CONFIG_SLUB_DEBUG_ON
will do the trick or passing "slub_debug" on the kernel command line.
