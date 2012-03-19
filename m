Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032947Ab2CSURr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:17:47 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:37957 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932341Ab2CSURp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:17:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: G7YBY6MVM1knwiV6CAXsJlbtYeyZVlICrnMQTL8liquD7O7
 jj4z2dgFJ6rTFW7J3QqUZzhSSd2GGLK7_f5Fj11eP0Z_wFbIPQ_OgqMqOOUB
 jThiV.e6YFQjU2T9Zbi69RlScGcV7iY8s6e53LyQPE1ksTdhOBDZ67LXZhdy
 LkCH.eKKllrg7NdHEL4Uz2vH0wY83EZkrxCBX9n8QYR4O7Cst5ccOQHcWhU7
 cxCVYh37z1pCl17JCYxHPv2VgNJddi.ZyiOKHD.rBhiPGIhisR1nkVXdVfhm
 QaIv95M4CGqx_XDSlEMRw_in2cRIYgfS2y9feQQ9cjXAiz7e1Xw5VDrGdeM_
 zGBpFzePXItkLZ0_H_yMX88__JbsLg9Uu_XIsh7l6_0hc8ldZaLTVLBUBkz3
 6
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 15:17:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
In-Reply-To: <20120319142046.GP24602@redhat.com>
Message-ID: <alpine.DEB.2.00.1203191513110.23632@router.home>
References: <20120316144028.036474157@chello.nl> <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins> <20120319130401.GI24602@redhat.com> <1332164371.18960.339.camel@twins> <20120319142046.GP24602@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Andrea Arcangeli wrote:

> Yeah I'll try to fix that but it's massively complex and frankly
> benchmarking wise it won't help much fixing that... so it's beyond the
> end of my todo list.

Well a word of caution here: SGI tried to implement automatic migration
schemes back in the 90's but they were never able to show a general
benefit of migration. The overhead added because of auto migration often
was not made up by true acceleration of the applications running on the
system. They were able to tune the automatic migration to work on
particular classes of applications but it never turned out to be generally
advantageous.

I wonder how we can verify that the automatic migration schemes are a real
benefit to the application? We have a history of developing a kernel that
decreases in performance as development proceeds. How can we make sure
that these schemes are actually beneficial overall for all loads and do
not cause regressions elsewhere?
