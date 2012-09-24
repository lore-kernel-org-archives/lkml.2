Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2IXJjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:39:12 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:64244 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2IXJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:39:08 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2012 05:39:08 EDT
Message-ID: <50602849.70506@cs.tu-berlin.de>
Date: Mon, 24 Sep 2012 11:30:49 +0200
From: =?ISO-8859-15?Q?=22Jan_H=2E_Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120919 Thunderbird/10.0.7
MIME-Version: 1.0
To: pjt@google.com
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [patch 00/16] sched: per-entity load-tracking
References: <20120823141422.444396696@google.com>
In-Reply-To: <20120823141422.444396696@google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul.

Am 23.08.2012 16:14, schrieb pjt@google.com:
> Please find attached the latest version for CFS load-tracking.

Originally, I thought, this series also takes care of
the leaf-cfs-runqueue ordering issue described here:

http://lkml.org/lkml/2011/7/18/86

Now, that I had a closer look, I see that it does not take
care of it.

Is there still any reason why the leaf_cfs_rq-list must be sorted?
Or could we just get rid of the ordering requirement, now?

(That seems easier than to fix the issue, as I suspect that
__update_blocked_averages_cpu() might still punch some holes
in the hierarchy in some edge cases.)

I'd like to see that issue resolved. :)

Regards
Jan
