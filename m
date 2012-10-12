Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab2JLSER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:04:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42283 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921Ab2JLSEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:04:15 -0400
Date: Fri, 12 Oct 2012 20:04:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iant@google.com" <iant@google.com>
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Message-ID: <20121012180411.GA26245@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Ma, Ling" <ling.ma@intel.com>,
	Konrad Rzeszutek Wilk <konrad@kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iant@google.com" <iant@google.com>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
 <20121011143527.GA2408@localhost.localdomain>
 <B2310DA9850C8743AA7AA0055500E90F0FD709F9@SHSMSX102.ccr.corp.intel.com>
 <20121012061813.GC9881@liondog.tnic>
 <B2310DA9850C8743AA7AA0055500E90F0FD70AC5@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2310DA9850C8743AA7AA0055500E90F0FD70AC5@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 09:07:43AM +0000, Ma, Ling wrote:
> > > > So is that also true for AMD CPUs?
> > > Although Bulldozer put 32byte instruction into decoupled 16byte entry
> > > buffers, it still decode 4 instructions per cycle, so 4 instructions
> > > will be fed into execution unit and
> > > 2 loads ,1 write will be issued per cycle.
> > 
> > I'd be very interested with what benchmarks are you seeing that perf
> > improvement on Atom and who knows, maybe I could find time to run them
> > on Bulldozer and see how your patch behaves there :-).M
> I use another benchmark from gcc, there are many code, and extract
> one simple benchmark, you may use it to test (cc -o copy_page
> copy_page.c), my initial result shows new copy page version is still
> better on bulldozer machine, because the machine is first release,
> please verify result. And CC to Ian.

Right, so benchmark shows around 20% speedup on Bulldozer but this is a
microbenchmark and before pursue this further, we need to verify whether
this brings any palpable speedup with a real benchmark, I don't know,
kernbench, netbench, whatever. Even something as boring as kernel build.
And probably check for perf regressions on the rest of the uarches.

Thanks.

-- 
Regards/Gruss,
    Boris.
