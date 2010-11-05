Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0KECAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:00:46 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:37730
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab0KECAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:00:44 -0400
Date: Thu, 4 Nov 2010 20:00:13 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: divide error in select_task_rq_fair()
Message-ID: <20101105020013.GA13484@helgaas.com>
References: <20101104041236.GA9389@helgaas.com>
 <1288847992.2718.37.camel@edumazet-laptop>
 <20101104142853.GA11656@helgaas.com>
 <1288881474.2659.123.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288881474.2659.123.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 03:37:54PM +0100, Eric Dumazet wrote:
> Le jeudi 04 novembre 2010 à 08:28 -0600, Bjorn Helgaas a écrit :
> > On Thu, Nov 04, 2010 at 06:19:52AM +0100, Eric Dumazet wrote:
> > > Le mercredi 03 novembre 2010 à 22:12 -0600, Bjorn Helgaas a écrit :
> > > > Hi,
> > > > 
> > > > With current upstream, I see the following crash at boot-time:
> > > > 
> > > >     Brought up 64 CPUs
> > > >     Total of 64 processors activated (289366.52 BogoMIPS).
> > > >     divide error: 0000 [#1] SMP 
> > > >     last sysfs file: 
> > > >     CPU 1 
> > > >     Modules linked in:
> > > > 
> > > >     Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00027-gff8b16d #271 /ProLiant DL980 G7
> > > >     RIP: 0010:[<ffffffff81034645>]  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
> > > > 
> > > > Complete dmesg below; let me know if you need more info.
> > > 
> > > Is the machine runs OK if you build a kernel with NR_CPUS=128 ?
> > 
> > Nope, it fails the same way with NR_CPUS=128.  Dmesg below.
> 
> Sorry, just try 256 or 512, it seems you have a pretty big machine ?

Is that going to help you debug the problem?  The solution is not going
to be something like "set NR_CPUS=x".  If NR_CPUS is too small, the
machine should still *boot*, even if we can't use all the CPUs in the
box.

Bjorn
