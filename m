Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1HKNFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:05:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab1HKNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:05:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
Date: Thu, 11 Aug 2011 15:05:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "weizeng.he@csr.com" <weizeng.he@csr.com>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com> <201108101624.27881.arnd@arndb.de> <20110810142808.GL10121@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110810142808.GL10121@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108111505.11887.arnd@arndb.de>
X-Provags-ID: V02:K0:lmuk+rP52Yk4EBFYPdy4zGZjUOnW7guMwF2tEKqIKj+
 d5ccBxjSWuY4wQJpOYqazkef+HaiBbgzd1hOZDkSW4m9+5REjR
 5oR7sMfo56vIkWXi23k0yesGjn3gBnBxnNOqJ/yUAHovOxxuaY
 Gnhv9lLI5rlsieWr7koQoVBOzHVk9/q5zbzs0m9MxLnM/dJNwn
 53BUCeHjyWOl5LKptS2zg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 August 2011, Will Deacon wrote:
> I was hoping that it was possible to have separate properties which describe
> the interrupt. So you could have something like pmu-interrupt <75> and
> abort-interrupt <76> rather than interrupts <75, 76>.

Ok, I see.

> I've not played with DT bindings before though, so if it's usually done with
> an ordered list then so be it!

A lot of the code assumes that the property is called 'interrupts' and that
it contains a fixed-length array of interrupt numbers, each for one specific
purpose.

Given that we have so many different meanings for the interrupts, I'm
not sure how this would work best in this case. According to
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0246f/CHDFHCFJ.html
this looks like a nested interrupt controller, i.e. the L2CC has its own mask
and status register with bits for each one of them. We could model these by
describing the l2cc interrupt controller with these registers and listing all
nine of the current inputs. I suspect however that it would be easier to just
assume that there is only one line for now, and treat the l2cc as a single
interrupt source with an internal status register.

	Arnd
