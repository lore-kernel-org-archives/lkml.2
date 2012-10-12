Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2JLGSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:18:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51696 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab2JLGSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:18:16 -0400
Date: Fri, 12 Oct 2012 08:18:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Message-ID: <20121012061813.GC9881@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Ma, Ling" <ling.ma@intel.com>,
	Konrad Rzeszutek Wilk <konrad@kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <20121011143527.GA2408@localhost.localdomain>
 <B2310DA9850C8743AA7AA0055500E90F0FD709F9@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2310DA9850C8743AA7AA0055500E90F0FD709F9@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 03:37:50AM +0000, Ma, Ling wrote:
> > > Load and write operation occupy about 35% and 10% respectively for
> > > most industry benchmarks. Fetched 16-aligned bytes code include about
> > > 4 instructions, implying 1.34(0.35 * 4) load, 0.4 write.
> > > Modern CPU support 2 load and 1 write per cycle, so throughput from
> > > write is bottleneck for memcpy or copy_page, and some slight CPU only
> > > support one mem operation per cycle. So it is enough to issue one
> > read
> > > and write instruction per cycle, and we can save registers.
> > 
> > So is that also true for AMD CPUs?
> Although Bulldozer put 32byte instruction into decoupled 16byte entry buffers,
> it still decode 4 instructions per cycle, so 4 instructions will be fed into execution unit and
> 2 loads ,1 write will be issued per cycle.

I'd be very interested with what benchmarks are you seeing that perf
improvement on Atom and who knows, maybe I could find time to run them
on Bulldozer and see how your patch behaves there :-).

Thanks.

-- 
Regards/Gruss,
    Boris.
