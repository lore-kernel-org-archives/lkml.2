Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1LAIh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:37:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:40977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1LAIhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:37:23 -0500
Message-ID: <1322728611.2921.315.camel@twins>
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>, PaulTurner <pjt@google.com>
Date: Thu, 01 Dec 2011 09:36:51 +0100
In-Reply-To: <1322702224.21329.88.camel@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
	 <1322135263.2921.12.camel@twins>
	 <1322524316.21329.64.camel@sbsiddha-desk.sc.intel.com>
	 <1322559859.2921.190.camel@twins>
	 <1322702224.21329.88.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 17:17 -0800, Suresh Siddha wrote:

> So was there any discussion regarding restoring the power savings mode
> at the recent scheduler bof? Even in the latest platforms, there is a
> small power savings when we consolidate the two tasks in two sockets
> onto one socket (though the power difference is shrinking). Turbo
> headroom also plays some role in this. Two tasks in two sockets
> potentially have more turbo headroom compared to the two tasks in one
> socket and thus increased performance with increased power.

Right, so if someone is very keen on it they could try now, but
otherwise it'll come once pjt's got his linsched stuff public and we're
going to do the big topology overhaul.

Anyway, for anybody going to work on it, I think the most important
first step is removing those crazy ass {smt,mc}_power knobs and their
multiple values :-)
