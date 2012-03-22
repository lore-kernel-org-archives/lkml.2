Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab2CVKiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:38:07 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:27729 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2CVKiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:38:03 -0400
From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix ftrace stack traces on x86_64
Date: Thu, 22 Mar 2012 11:18:19 +0100
Message-Id: <1332411501-8059-1-git-send-email-wolfgang.mauerer@siemens.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stack tracing with ftrace does currently not work properly when
trace-cmd is used on x86_64 machines -- only half of each stack
entry is shown (things work fine with the ftrace debugfs
interface):

mutextest-7604  [001]   664.978289: user_stack:
 => (000000002a7ac565)
 => (000000002a7a6070)
 => (00000000ffffffff)

The following two patches modify the kernel to use the proper
trace_printk format, and fix trace_cmd to parse the format
correctly:

mutextest-7604  [001]   664.978289: user_stack:
 => (00007f342a7ac565)
 => (00007f342a7a6070)
 => (ffffffffffffffff)

Cheers, Wolfgang

--
Siemens AG
Corporate Competence Centre Embedded Linux

>From Wolfgang Mauerer <wolfgang.mauerer@siemens.com> # This line is ignored.
From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Subject: 
In-Reply-To: 

