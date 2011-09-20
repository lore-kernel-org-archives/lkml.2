Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1ITQCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:02:14 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:40752 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750806Ab1ITQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:02:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lIOFQusVM1n5LUX36DTuhJYr1pQdZsP3QOEjedICgywbdUx
 Ep8a2jrdmwMB7H8z2VqgvSENAOl6HSCT.rL1S5cP1PDRyrvWd5YEOXTh5TqI
 GXI18UwQnN4XctFGPDpYfyTFuUFouw58aMrE7jAF4j1xBuxuOMjQrRRg2WtX
 VbG01DkTMfxg.taK_CWUTiws1uU0lbfPygwhmHciAEhe3NNQ9cJnPU2OFPgH
 .mkrVDY6Iz2u.VjwMfHAkoJ1i.tgS7_ptbsvh4DXk_LoRgCmLsCKnLaWfjuX
 h2IrV8qqtcumAJqxF4dmKgO0WYyjoTz4_Xk8wtheM3NwE0JLQ9mjtzCQHCpl
 nF1p_w24NtouSmHDm6BHpQNgq1Lej4LGnHD9H42Ps3cJHl44qSDdcsUd0wTa
 tNFDmj.9VeyyPWSAc6P70ZLE-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 11:02:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <alpine.LFD.2.02.1109201703560.2723@ionos>
Message-ID: <alpine.DEB.2.00.1109201059590.8056@router.home>
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org> <alpine.DEB.2.00.1109191657150.19059@router.home> <alpine.LFD.2.02.1109201334590.2723@ionos> <alpine.DEB.2.00.1109200947100.8056@router.home>
 <alpine.LFD.2.02.1109201703560.2723@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Thomas Gleixner wrote:

> I want to get rid of them alltogether. They are crap by design and
> prone to be used wrong without a sensible way to detect that.

Counter increments have been done this way for a very long time. This is
a pretty well established way of doing things in the kernel that was
expanded and made better by avoid preempt disable/enable around these per
cpu pointer increments.


> Right, and that's the main problem. We have no fricking way to debug
> this, so they should have never been there in the first place. And you
> simply CANNOT prevent people from getting this wrong w/o proper
> debugging and annotation. Even YOU and Tejun made bogus conversion w/o
> noticing, but you expect that others get it right?

Bogus conversions?

> So stop defending that trainwreck and help out with fixing the mess
> you created in a proper and debugable way!

You want debugging to ensure that this_cpu ops always access the intended
per cpu area? But the point of these operations is to be used in kernel
locations where the use of any per cpu area is satisfactory.

