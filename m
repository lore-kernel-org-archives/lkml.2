Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0LVJv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:51:57 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57740 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0LVJv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:51:56 -0500
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <4D11C362.1060100@redhat.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
	 <1292859744.5021.4.camel@laptop> <20101220155737.GA1742@nowhere>
	 <1292861799.5021.27.camel@laptop> <20101221012418.GI1715@nowhere>
	 <1292919280.5021.203.camel@laptop> <4D10B2E9.9040806@redhat.com>
	 <20101221170512.GM1750@nowhere> <4D10EF3D.3070000@redhat.com>
	 <20101221210831.GS1750@nowhere>  <4D11C362.1060100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 10:51:44 +0100
Message-ID: <1293011504.2170.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 11:22 +0200, Avi Kivity wrote:
> > Makes sense. And that integrates well with Peter's idea of creating a
> > new cpuset attribute for the nohz tasks.
> >
> > But instead of making this detection from the scheduler, I think this
> > should be done from the tick: if there is only one task running, set
> > it the TF flag.
> >
> > But anyway, that's an optimisation. We can start with setting that flag
> > on every task in that cpuset.
> 
> So long as we start without the new knob. 

Right, so one of the things we can do is let the tick disable itself
when it finds there is no pending work left and set the TIF bit when
needed. We should then also rate-limit things so as not to
enable/disable the tick too often, but that would potentially allow us
to do away with all knobs.
