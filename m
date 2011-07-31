Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1GaUA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:00:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:44615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1GaUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:00:49 -0400
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid
 overriding CONFIG_64BIT
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Date: Sun, 31 Jul 2011 21:00:27 +0100
In-Reply-To: <CACqU3MVbFonB+qFyLNj2bKU9KLFx-buk7uv=cA_NGfL+4tP9uA@mail.gmail.com>
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
	 <CACqU3MVbFonB+qFyLNj2bKU9KLFx-buk7uv=cA_NGfL+4tP9uA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312142430.12369.21.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 15:40 -0400, Arnaud Lacombe wrote:
> FWIW, you are still breaking `scripts/checkstack.pl',
> `scripts/tags.sh' (all UML related)

Can you explain the nature of the breakage? It's probably also easy to
fix (or was already arguably broken), but it would be helpful if you'd
point at what you think is wrong rather than making me guess.

>  and this change will lead users of ARCH=i386 to trigger the
> cross-compile mode of modpost introduced in
> 4ce6efed48d736e3384c39ff87bda723e1f8e041.

That doesn't seem unreasonable. After all, if the .config values are no
longer being forcibly overridden to match the build host, you no longer
*need* to add ARCH=i386 on the command line just to make the build
system honour your existing configuration with CONFIG_64BIT=n. So
there's absolutely no point in having ARCH=i386 there. If you want the
more stringent checks, don't do that then. But I'll take a look at this
too. Thanks for actually giving enough detail.

-- 
dwmw2

