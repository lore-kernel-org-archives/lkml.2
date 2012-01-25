Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2AYF3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:29:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53117 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2AYF3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:29:36 -0500
Message-ID: <1327469372.14373.31.camel@edumazet-laptop>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Date: Wed, 25 Jan 2012 06:29:32 +0100
In-Reply-To: <20120124172732.19b3d9f4.akpm@linux-foundation.org>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1327449683.14373.12.camel@edumazet-laptop>
	 <20120124161221.032325d1.akpm@linux-foundation.org>
	 <1327450945.14373.24.camel@edumazet-laptop>
	 <20120124172732.19b3d9f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 17:27 -0800, Andrew Morton a écrit :

> I had a fiddle on an 8-way x86_64 machine.  I'm unable to demonstrate
> any improvement for either of
> 
> time (for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done)
> time (for i in $(seq 1000); do; cat /proc/1/stat > /dev/null; done)
> 
> oh well.

What size is /proc/stat ?

wc -c /proc/stat

If under 4096, there is no problem with existing code.

I had the problem on a 16-way machine.





