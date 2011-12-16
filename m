Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972Ab1LPXJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:09:52 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:35954
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab1LPXJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:09:46 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPV:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 16 Dec 2011 18:09:19 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: perf_event hard locks in 3.1.5
Message-ID: <alpine.DEB.2.00.1112161804280.8779@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I had a PAPI user report that perf_event usage (such as running
the PAPI tests) would cause hard lockups on his 3.1.x kernel
(from ARCH linux).

After some tedious bisection of the .config file, I found that the issue
happens when 
  CONFIG_SLUB=y
  CONFIG_SLUB_DEBUG=y
is enabled.  Having a kernel with that enabled and stressing the 
perf_event subsystem will eventually cause lockups or hard crashes.

I'll try to narrow things further, I've run out of time before the 
weekend.  Just posting this in case anyone else wants to investigate the 
problem.

Vince
vweaver1@eecs.utk.edu

