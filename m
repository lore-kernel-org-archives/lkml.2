Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2AZBET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:04:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2AZBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:04:18 -0500
Date: Wed, 25 Jan 2012 17:04:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120125170416.385ee9fa.akpm@linux-foundation.org>
In-Reply-To: <1327469372.14373.31.camel@edumazet-laptop>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
	<20120124161221.032325d1.akpm@linux-foundation.org>
	<1327450945.14373.24.camel@edumazet-laptop>
	<20120124172732.19b3d9f4.akpm@linux-foundation.org>
	<1327469372.14373.31.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 06:29:32 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le mardi 24 janvier 2012 __ 17:27 -0800, Andrew Morton a __crit :
> 
> > I had a fiddle on an 8-way x86_64 machine.  I'm unable to demonstrate
> > any improvement for either of
> > 
> > time (for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done)
> > time (for i in $(seq 1000); do; cat /proc/1/stat > /dev/null; done)
> > 
> > oh well.
> 
> What size is /proc/stat ?

About 40mm, but it depends on the font size.

> wc -c /proc/stat
> 
> If under 4096, there is no problem with existing code.

akpm2:/home/akpm> wc -c /proc/stat 
2800 /proc/stat

> I had the problem on a 16-way machine.

OK..
