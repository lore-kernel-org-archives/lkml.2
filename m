Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2C1BNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 21:13:06 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:31182 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754332Ab2C1BNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 21:13:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: A2JvmOgVM1lUxMnDdtVWjCR60OQpVUzckQnBKr.AZ8p2IOm
 QZoqidHXWRmki0ked1.cFo.QTiCJeAplIRGyI98u_ZMSKo9lec9t9V5zc2mm
 f8pwGK8KSnhEPwIJuZI8A6ae9JWAPi42t62L0cX_z9JYh1YwovD9lUreswSf
 pzzMO7S1xlytd.UrdIOjdMcJisHpjpIFbcR9DFJhy2tBqvfSWzEimDVeyU55
 rxgJzpUulBZZhW5orBoNbDUJmQ.2T_P6FO5U9_41ud0Hj7Z.4V08OZyMf9La
 Wc8jdmCLgog1Z0sfHyJCLedtK8rXgqDZHTXlyg6lyhSwn5MWQpCf2h5E9mtM
 lP.gDrtz8Eo.FPSH9ndRubTSGpkpB4U.LeIW_ozniPBEC1Ejl13iEGBcKa.U
 Y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Mar 2012 20:12:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
In-Reply-To: <1332866823.16159.246.camel@twins>
Message-ID: <alpine.DEB.2.00.1203271943320.11825@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-10-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210950500.20482@router.home> <20120327105034.GA13196@somewhere> <alpine.DEB.2.00.1203271106130.1170@router.home>
 <1332866823.16159.246.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Peter Zijlstra wrote:

> On Tue, 2012-03-27 at 11:08 -0500, Christoph Lameter wrote:
> >
> > I wish you would disentangle the nohz work from the cpusets. Cpusets is
> > aged and being replaced by cgroups. And the cgroup work is something that
> > is not suitable for many loads given the VM overhead added.
>
> What VM overhead? Are you talking about the memcg nonsense? That's
> entirely optional, you don't need to either build that or enable it.

cgroups in general cause a much more complex VM processing with multiple
LRUs and additional checks in various places.

Even just adding cpusets enables the group scheduler functionality f.e.
which creates significantly larger scheduling latencies. Also complicates
key allocation VM paths etc etc.

> And if we ever get rid of that multiple hierarchy nonsense I don't see a
> reason to get rid of cpuset at all. The only reason to want to replace
> it is to avoid the dis-joint-ness it has with the cpu controller (and
> possible the memcg one).

I like cpusets much more than cgroups. I agree with you.

But I am not sure that cpusets are needed for nohz. We already have an
isolcpu set and it sounds to me that nohz is generally useful.

It would seem that the nohz patches would be much simpler if it would not
require cpusets to administer. The only thing that would be needed is to
have one cpu that is not subject to nohz. The logical choice is a
timekeeper cpu (which is usually cpu 0). Having that configurable would be
an extra bonus.

