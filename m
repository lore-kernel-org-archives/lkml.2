Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab2BAU1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:27:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2BAU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:27:46 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=p-wZvnPcUTwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=qQEtgr_gvJB5gL5YKMAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328128063.5882.80.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet
 driver to blame? Yep
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: RT <linux-rt-users@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Tim Sander <tstone@iss.tu-darmstadt.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        Micha Nelissen <micha@neli.hopto.org>,
        Holger Brunck <holger.brunck@keymile.com>
Date: Wed, 01 Feb 2012 15:27:43 -0500
In-Reply-To: <201201251031.48983.tim.sander@hbm.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <201201181211.45011.tim.sander@hbm.com>
	 <201201241152.21472.tim.sander@hbm.com>
	 <201201251031.48983.tim.sander@hbm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 10:31 +0100, Tim Sander wrote:

> Bad news, the ksoftirq(sirq-net-tx) error seems to happen not so often any 
> more but it still happens :-(.

Tim,

Is the system still usable when this happens? If so, can you configure
in ftrace, and run a trace on what ksoftirq is doing:

mkdir /debug
mount -t debugfs nodev /debug
cd /debug/tracing
echo <pid-of-ksoftirq> > set_ftrace_pid
echo function > current_tracer
cat trace

Thanks!

-- Steve


