Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1KIO3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:29:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1KIO3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:29:02 -0500
Subject: Re: [PATCH RFC tip/core/rcu 19/28] nohz: Allow rcu extended
 quiescent state handling seperately from tick stop
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Date: Wed, 09 Nov 2011 15:28:07 +0100
In-Reply-To: <20111103160656.GC2287@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111103040003.GE2042@leaf> <20111103115426.GD8198@somewhere.redhat.com>
	 <20111103133231.GA2287@linux.vnet.ibm.com> <20111103153102.GC18443@leaf>
	 <20111103160656.GC2287@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320848887.19727.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 09:06 -0700, Paul E. McKenney wrote:
> > Mostly I think that since this series tries to separate the concepts of
> > "idle nohz" and "rcu extended quiescent state", we should end up with
> > two entirely separate functions delimiting those two, without any
> > functions that poke both with correspondingly complex compound names.
> 
> Having four API members rather than the current six does seem quite
> attractive to me.  Frederic, any reason why this approach won't work? 

Quite agreed. And since you seem to be touching most archs anyway,
touching them all isn't much more extra work.
