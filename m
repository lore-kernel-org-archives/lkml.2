Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1G3W6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:58:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:48781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1G3W5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:57:53 -0400
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid
 overriding CONFIG_64BIT
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Sat, 30 Jul 2011 23:57:43 +0100
In-Reply-To: <CACqU3MWDqyWGz72jTd01OdeVFT=X9+m-6AjNt6tTLj2oG2vB7w@mail.gmail.com>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <1306795186.2029.459.camel@i7.infradead.org>
	 <BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	 <1306856937.27477.3.camel@i7.infradead.org>
	 <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	 <4E0495F4.7080300@suse.cz> <1311986969.20983.52.camel@i7.infradead.org>
	 <CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
	 <alpine.LFD.2.02.1107301716430.21839@localhost6.localdomain6>
	 <CACqU3MVY89L3B3=eFrmsgD2wzXtbQHssPm4D_-VZGEWNYBR4-Q@mail.gmail.com>
	 <4E34548F.9040909@zytor.com> <1312059539.22074.16.camel@i7.infradead.org>
	 <CACqU3MWDqyWGz72jTd01OdeVFT=X9+m-6AjNt6tTLj2oG2vB7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1312066665.22074.49.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 18:21 -0400, Arnaud Lacombe wrote:
> > I'll work on a patch to fix that, and then it will be fine when the
> > default for SUBARCH changes to be "x86".
> >
> I still fail to see why you want it that way... You want both ARCH and
> SUBARCH to be 'x86' ?

See the way that SUBARCH is inferred in the Makefile, and then ARCH is
set to match it (unless ARCH is set by the user).

To change the default setting of ARCH, we actually change the inference
of *SUBARCH*. And yes, in the common case they are both the *same*; the
SUBARCH variable doesn't really do anything except work as a temporary
variable holding the default setting for ARCH.

In an ARCH=um build, of course they *are* different, and SUBARCH is
actually used for more than that.

> This starts to be a hell lots of deep changes just to fix i386 build
> under a fast x86-64 without having to specify ARCH=i386. That job
> alone can be done a lot easier. 

It's not just that. It's also about making things work properly as
config options — so we can finally complete the merge of arch/i386 and
arch/x86_64, which directories we deleted almost four years ago, into
the single 'x86' architecture.

After a few 'unrelated' cleanups to how $(SUBARCH) is handled, the patch
to make SUBARCH=x86 work in um really isn't that intrusive at all; I'll
post the sequence shortly.

We *could* preserve the legacy inference of SUBARCH={i386,x86_64} *just*
for the ARCH=um case, but I think it's better not to.

-- 
dwmw2

