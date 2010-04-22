Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0DVOvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:51:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470Ab0DVOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:51:09 -0400
Date: Thu, 22 Apr 2010 07:48:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Greg KH <gregkh@suse.de>, Rik van Riel <riel@redhat.com>,
       John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
In-Reply-To: <20100422102852.72837494@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org>
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org> <20100421193350.GU16427@zorg.emea.sgi.com>
 <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de> <4BCF80F2.2010906@redhat.com> <20100421232200.GA22877@suse.de> <20100422102852.72837494@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Apr 2010, Alan Cox wrote:
>
> > Distros don't want to take a patch that adds a new boot param that is
> > not accepted upstream, otherwise they will be stuck forward porting it
> > from now until, well, forever :)
> 
> So for an obscure IA64 specific problem you want the upstream kernel to
> port it forward forever instead ?

Ehh. Nobody does ia64 any more. It's dead, Jim.

This is x86. SGI finally long ago gave up on the Intel/HP clusterf*ck.

Which I'm not entirely sure makes the case for the kernel parameter much 
stronger, though. I wonder if it's not more appropriate to just have a 
total hack saying

	if (max_pids < N * max_cpus) {
		printk("We have %d CPUs, increasing max_pids to %d\n");
		max_pids = N*max_cpus;
	}

where "N" is just some random fudge-factor. It's reasonable to expect a 
certain minimum number of processes per CPU, after all.

		Linus
