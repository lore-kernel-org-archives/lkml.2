Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0JFTYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:24:06 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:57715
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933074Ab0JFTYD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:24:03 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2cK1432N98dN9371Pzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L9VV5O-01-VP1-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 21:22:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Paul Mundt <lethal@linux-sh.org>, Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Subject: Re: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate
 init/exit
Message-ID: <20101006192235.GA13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org>
 <20101006133309.GP13563@erda.amd.com>
 <20101006144921.GQ13563@erda.amd.com>
 <20101006145311.GA3754@linux-sh.org>
 <20101006145903.GR13563@erda.amd.com>
 <AANLkTikGQe99k_fK5pZtkn-ht9jgC0guDkn28dSedjUo@mail.gmail.com>
 <20101006184407.GY13563@erda.amd.com>
 <AANLkTin579dqJsdtpesJ0erWP3Pgi39XHQs46xMAGJDW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTin579dqJsdtpesJ0erWP3Pgi39XHQs46xMAGJDW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.10 14:58:06, Grant Likely wrote:
> On Wed, Oct 6, 2010 at 12:44 PM, Robert Richter <robert.richter@amd.com> wrote:
> > On 06.10.10 14:23:17, Grant Likely wrote:
> >> >> diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> >> >> index b336cd9..76d97a5 100644
> >> >> --- a/drivers/oprofile/oprof.c
> >> >> +++ b/drivers/oprofile/oprof.c
> >> >> @@ -252,6 +252,8 @@ static int __init oprofile_init(void)
> >> >>  {
> >> >>       int err;
> >> >>
> >> >> +     memset(&oprofile_ops, 0, sizeof(struct oprofile_operations));
> >> >> +
> >> >
> >> > Yes, this looks much better. Thanks Paul.
> >>
> >> oprofile_ops is allocated in bss and so is already zeroed.  No need to
> >> do it explicitly.
> >
> > Before oprofile_arch_init() it isn't necessarily needed, but we should
> > definitely add it before oprofile_timer_init(). For code readability I
> > would rather tend to let the first in too.
> 
> ?  Sorry, I don't understand what you're trying to say.  Because
> oprofile_ops is statically allocated in bss; it will be zeroed before
> *any* of the init hooks is called.

The first call to oprofile_arch_init() might leave a dirty struct, but
as Paul just pointed out the function is aware of it and cleans up the
struct during init where necessary. The backtrace callback setup will
be reused if arch init fails (seems to be an ugly hack). So it is
better not to zero the struct then and keep everything unchanged.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

