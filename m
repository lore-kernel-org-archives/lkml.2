Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab2EIPkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:40:21 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:32681 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758475Ab2EIPkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:40:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XC9FZQEVM1nNPhHQhtZaMe6_k4_tpxKeUozb4d4Obfnmhb2
 uLUflUGyxERuyLI2U612zbL7B6TavXiVRo1kr90z.wa8DbrKvv2XUcCS41hV
 .UINKa1d5MKXIUDRdYKO5I_dkWOaNXwWapSc.wvgp6k5fUxv31VmzcYwJBJ.
 x4Hg1DfkdNayH_nnlvX1nzRLEj_IRuZNTOq4ueM.gS.sqC_mqSPMopVb.qZH
 CfgcETyfFj66ST2qwvk_CbZFKwp.JXnpfoUuiIZfrlXxaDC1pKqEOLI2pN5z
 dTbDiG4DiotHboyE_ISOyOxLJKeDDfz0jUhG_a4YHa_lL3bbGUiZelgpv0hW
 z7DoBGQw3QY4GT0BJscIk7.hGzVGuEghnpvlqNMMfjpVsye5upt05eg1bAW8
 .
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 10:40:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Galbraith <efault@gmx.de>
cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <1336577622.16079.39.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1205091039170.11225@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins> <alpine.DEB.2.00.1205081035550.27713@router.home> <1336492081.8226.13.camel@twins> <alpine.DEB.2.00.1205081054310.27713@router.home>
 <1336493768.8226.29.camel@twins> <1336506601.7400.21.camel@marge.simpson.net> <alpine.DEB.2.00.1205081541010.1391@router.home> <1336537289.7365.62.camel@marge.simpson.net> <alpine.DEB.2.00.1205090915430.8171@router.home> <1336574836.16079.17.camel@marge.simpson.net>
 <alpine.DEB.2.00.1205091001480.10177@router.home> <1336577622.16079.39.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Mike Galbraith wrote:

> I don't like cgroups much, but I've become rather fond of cpusets.

Well that we agree on. And given the future of many more cores it makes
just sense to segment the system on processor and node boundaries instead
of adding overhead for management of slices of that.


