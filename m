Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1ITO6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:58:47 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:21751 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751593Ab1ITO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:58:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qyfaZlkVM1khvTqGRf.fz8GOCDPO2xLRclpmw6V_FWVnAqj
 PJFMJ7YZYUNXVZFheiNWkB2vywyok1dJPcdtyuXfxai8TKgP__dnB.0eLU10
 lMi2WmtZbje2t5bREfxrNWvvpVUplcurQx2hz4WUEMpyVZQbfVLluMPrU9K8
 L_FGiAjQU8bUrL.VdBXEUQOSzBo652dM_Z9v33OgW2Ackwe7liCkZWztbk_w
 UNFEHSOrmGaBQOCe2JcPAvw_EY7NjIUSEFxGEcONdlm6W_YRgUrGBX.Zza9j
 CVZgu7nEfdH1VUIfl4iBYFpJI9Yds0lE8SRSxWswHzODC6C.omvW5LPyW4dn
 KhALfk6hsqj1XJjArgf7FxzMpVEtlZbFrE6qyujvzS5uKkjM-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 09:58:41 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Valdis.Kletnieks@vt.edu, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <alpine.LFD.2.02.1109201549520.2723@ionos>
Message-ID: <alpine.DEB.2.00.1109200957500.8056@router.home>
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home>            <1316487977.29966.32.camel@gandalf.stny.rr.com> <27409.1316522696@turing-police.cc.vt.edu> <alpine.LFD.2.02.1109201549520.2723@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Thomas Gleixner wrote:

> > What's the latency hit on those very few locations if we simply put our
> > collective foot down and not support a preemptable version of this_cpu_*()?
> > "Yes, you *could* preempt here, but for our collective sanity that's not
> > supported"...
>
> Full ack.

Latency hit could be very significant in various critical kernel paths.
Especially network subsystem, vm event counters etc.

