Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0LHPmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:42:10 -0500
Received: from luminismail.carleton.ca ([134.117.2.27]:51729 "EHLO
	luminismail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0LHPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:42:08 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 10:42:08 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Message-id: <4CFF993D.3050504@ccsl.carleton.ca>
Date: Wed, 08 Dec 2010 09:42:05 -0500
From: Mohammad R Nikseresht <nikser@ccsl.carleton.ca>
User-Agent: Thunderbird 2.0.0.24 (X11/20101126)
To: linux-kernel@vger.kernel.org
Subject: lowering interactive scheduling latency with no TTYs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have developed a Linux scheduling enhancement that gives significantly
lower scheduling latency for interactive processes (20+% improvement
versus the Mike Galbraith's recent "200 line" scheduling patch, 80+%
improvement versus 2.6.35 stock scheduler) but without any reference to
TTYs or use of cgroups.  It also reduces latency for network server
processes under background load (mysql, apache).

My enhancement is currently implemented as a SystemTap script; as a
result general scheduling latency is currently a bit high.  I am
currently working on translating it into a kernel patch.

More information is here, including a full description in a technical
report, benchmarks, and my SystemTap script:

   http://people.scs.carleton.ca/~mniksere/appeasement.html

What follows is a brief description of how Customer Appeasement
scheduling works.

The basic idea behind my enhancement, which I call the Customer
Appeasement scheduling policy, is to boost the priority of critical processes
based upon their socket-level interactions. The assumption is that the processes that are 
interacting with a customer have a higher non-zero socket read operations.
Based on this I increase their priority temporary whenever they have a non-zero socket 
read operation to let them to respond to the customer request faster.
The exact amount of priority increase and the time interval that the process 
receives this extra priority depends on the system load. The higher the system load
the higer the priority and the longer the time interval.

Please try running it, I'd appreciate your feedback,

Thanks,

--
Mohammad Nikseresht


