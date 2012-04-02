Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2DBRX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:23:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59144 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2DBRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHYoAtxvcW1B47jGm4GYZpc1vB6+ovyCk0njU4LFXsaAg@mail.gmail.com>
References: <20120316144028.036474157@chello.nl>
	<4F670325.7080700@redhat.com>
	<1332155527.18960.292.camel@twins>
	<20120319130401.GI24602@redhat.com>
	<1332163591.18960.334.camel@twins>
	<20120319135745.GL24602@redhat.com>
	<4F673D73.90106@redhat.com>
	<20120319143002.GQ24602@redhat.com>
	<1332182523.18960.372.camel@twins>
	<4F69022D.3080300@redhat.com>
	<CAOJsxLHPc7QxdsUADikgeqQo7WVCzUD1KoHRT7Ngr7xXM_F7ig@mail.gmail.com>
	<4F79D9F1.7030504@redhat.com>
	<CAOJsxLGJorTZL7OhNzfpX0T1LQHrLs59LVr1WYX_8VAi8BF35g@mail.gmail.com>
	<CAOJsxLHYoAtxvcW1B47jGm4GYZpc1vB6+ovyCk0njU4LFXsaAg@mail.gmail.com>
Date: Mon, 2 Apr 2012 20:23:57 +0300
X-Google-Sender-Auth: HdDznIoyqCHOKyekMOX9kV5SQAo
Message-ID: <CAOJsxLEwPKCq9iOWu+ku-1AwNTsqWBURR-3Ui4orgetPzP1cfg@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 8:12 PM, Pekka Enberg <penberg@kernel.org> wrote:
> I guess benchmarks that represent typical JVM server workloads are
> tomcat and tradesoap. You can run them easily with this small shell
> script:

The default configuration for tomcat is too small to be interesting.
Here's a fixed up version which uses larger data set and 2 threads per
CPU.

#!/bin/sh

JAR=dacapo-9.12-bach.jar

if [ ! -f $JAR ];
then
  wget http://sourceforge.net/projects/dacapobench/files/9.12-bach/$JAR/download
fi

java -jar $JAR -k 2 -s large tomcat | grep PASSED

java -jar $JAR tradesoap | grep PASSED
