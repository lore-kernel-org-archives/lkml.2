Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2HTSx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:53:59 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:20568 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab2HTSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:53:57 -0400
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz4015Izz1202hzzz2dh87h2a8h668h839h8e2h8e3h944he96h107ahbe9i)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 20 Aug 2012 14:53:52 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
X-X-Sender: vweaver1@cl320.icl.utk.edu
To: <linux-kernel@vger.kernel.org>
CC: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: perf: PERF_EVENT_IOC_RESET and multiplexing
Message-ID: <alpine.DEB.2.00.1208201447150.29057@cl320.icl.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I have a perf API question.

When I run PERF_EVENT_IOC_RESET, all it resets is the event count.
It does not reset the PERF_FORMAT_TOTAL_TIME_ENABLED or
PERF_FORMAT_TOTAL_TIME_RUNNING values.

Is this expected?  It means if I'm trying to do multiplexing and want to 
reset the counts to zero, there's no way to reset the enabled/running 
values.

I suppose I can just close/reopen the events, or allocate some space to 
store the previous values, but that seems like unncessary overhead.



As an aside while I have your attention, can someone explain the 
difference between the "inherit" and the "inherit_stat" options in
perf.attr?  I can't seem to make a test case exhibit a difference, and
the events/core.c code in the kernel is a horrible wall of uncommented 
code that is nearly impossible to follow.

Thanks,

Vince
vweaver1@eecs.utk.edu

