Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0LUSSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:18:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab0LUSSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:18:43 -0500
Message-ID: <4D10EF3D.3070000@redhat.com>
Date: Tue, 21 Dec 2010 20:17:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com> <1292858662-5650-16-git-send-email-fweisbec@gmail.com> <1292859744.5021.4.camel@laptop> <20101220155737.GA1742@nowhere> <1292861799.5021.27.camel@laptop> <20101221012418.GI1715@nowhere> <1292919280.5021.203.camel@laptop> <4D10B2E9.9040806@redhat.com> <20101221170512.GM1750@nowhere>
In-Reply-To: <20101221170512.GM1750@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 07:05 PM, Frederic Weisbecker wrote:
> >
> >  For an example of a per-cpu flag that is checked on every exit with
> >  zero additional overhead on the flag clear case, look at
> >  TIF_USER_RETURN_NOTIFY.
>
> Right, but the problem is actually that if we want to automate the nohz
> attribute on every tasks, then you need you have this flag set for
> all of these threads.
>
> No problem with that, but if nobody wants the nohz attribute, we don't
> need to force that slow path.

When the scheduler detects the task is all alone, it sets the flag; when 
it blocks, or if another task joins, it drops the flag (at most one task 
per cpu has the flag set).

Does that work?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

