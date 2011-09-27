Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1I0Mo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:44:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1I0MoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:44:24 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=48nsp6s6xvkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=cRPI7mre7TYTbAjl984A:9 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110927124022.484200394@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Sep 2011 08:40:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>
Subject: [PATCH v2 0/3][RT] [RT] rt: patches to postpone migrate disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I found a slight bug in the original patch series. As the
tsk_cpu_allowed() returns a mask dependent on the migrate_disable set
or not, the migrate_disable needs to be cleared in the migrate_enable()
before calling tsk_cpu_allowed(). I fixed that and added a comment
to let others know of this side effect.

-- Steve

