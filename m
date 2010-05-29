Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0E2BB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 21:01:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab0E2BB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 21:01:26 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=9Iazo0IoXQQA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=3ndwz-Ti1iAv6WISMi0A:9 a=W6HHTXRjgkDE3RnQHKnRE0RGDBUA:4 a=PUjeQqilurYA:10 a=0kPLrQdw3YYA:10 a=EeVtCjB_Kj1sCrb3:21 a=cCgeKfN588VDJe5k:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [BUG] kacpi_notify goes into an infinite loop (luckly it calls
 cond_resched)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, clarkt@cnsp.com,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 28 May 2010 21:01:22 -0400
Message-ID: <1275094882.22648.607.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just replaced Windows with F12 on my wife's computer, to have nothing
but issues. But anyway, one of the issues I had on this box was in
vanilla linux kernel 2.6.34 (all the fedora kernels had other issues),
the kacpi_notify would go into an infinite loop.

I debugged it a bit with ftrace and saw that the kacpi_notify workqueue
was constantly requeuing itself (thanks to the workqueue trace events).

I bisected this, and it came down to this change:

commit fa80945269f312bc609e8384302f58b03c916e12
Author: Thomas Renninger <trenn@suse.de>
Date:   Sat Feb 20 11:44:27 2010 +0100

    ACPI thermal: Don't invalidate thermal zone if critical trip point is bad


I checked out 2.6.34 again, and reverted this patch, and the problem
went away.

The box is an old Compaq Presario that I bought in 2003 or 2004.

-- Steve


