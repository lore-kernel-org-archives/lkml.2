Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1LTJ3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:29:07 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:59296 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1LTJ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:28:58 -0500
X-AuditID: b753bd60-98392ba000007b1b-44-4ef054bf4e63
X-AuditID: b753bd60-98392ba000007b1b-44-4ef054bf4e63
Message-ID: <4EF054B4.7050308@hitachi.com>
Date: Tue, 20 Dec 2011 18:26:12 +0900
From: Hiraku TOYOOKA <hiraku.toyooka.gu@hitachi.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: srostedt@redhat.com, linux-kernel@vger.kernel.org
Cc: masami.hiramatsu.pt@hitachi.com, yrl.pp-manager.tt@hitachi.com
Subject: trace: multiple ring buffers
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven,
I'm researching RAS features for real-time systems.

I'm interested in the multiple ring buffer support on ftrace because of
following reasons.

* To preserve particular events such as error or fault over a long time. These
events are useful for failure analysis. But these events could be lost when
other trace events are generated in large quantities in one buffer. If there is
only one buffer, we have to prepare one big buffer so that the particular events
are not overwritten by other events. It wastes memory as a result.

* To use the same trace events for different purposes. For example, I'd like to
collect trace events and detect performance degradation (using sched_switch
event, etc.), while running flight recorder for failure analysis.

Multiple buffer support makes these really easy. I'm sure that other users wish
to use it. Of course, it will introduce some complexities to ftrace code.

So, I'd like to implement following the features on ftrace.

* A mechanism to increase buffers on demand
* A mechanism to change destination buffer(s) of each trace event via debugfs

I have heard from Masami that you have some ideas of multiple buffers. If so,
could you tell me the ideas? I'd like to cooperate with you to develop multiple
buffers.

Best regards,
Hiraku Toyooka


