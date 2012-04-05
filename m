Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2DETTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:19:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:58207 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab2DETTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:19:33 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <mark.asselstine@windriver.com>
Subject: [PATCH 0/3] trace-cmd fixes for latency tracing record and report
Date: Thu, 5 Apr 2012 15:19:43 -0400
Message-ID: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches are for the latency-cmd tree.

trace-cmd latency tracing is broken due to segfaults and disappearing 'trace'
logs. Recent commits seem to have broken latency tracers by changing when things are
being initialized or leaving some things uninitialized since they are unused in certain
circumstances. The first two patches address segfaults when running both the record and
report commands caused by attempts to access uninitialized pointers. The last patch
avoids empty reports due to the premature clearing of the 'trace' log caused by resetting
the current_tracer to 'nop'. We still set the 'current_tracer' to 'nop', just after we
have grabbed the data we want.

These changes have been tested on top of the latest trace-cmd tree as well as
on top of the trace-cmd-v1.2 tag point in conjunction with the latest mainline
kernel as well as an older 2.6.34 vintage kernel.

Tests were done with
# ./trace-cmd record -p irqsoff ls /bin
# ./trace-cmd report

Regards,
Mark Asselstine
