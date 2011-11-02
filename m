Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1KBPDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:03:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32776 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab1KBPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:03:41 -0400
Date: Wed, 2 Nov 2011 20:32:55 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: function_graph selftest fails with !DYNAMIC
Message-ID: <20111102150255.GA6973@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function_graph selftest fails when CONFIG_DYNAMIC_FTRACE is not set
(tested on x86-64) on current kernels:

[    0.300124] Testing tracer function: PASSED
[    0.446092] Testing tracer function_graph: .. no entries found ..FAILED!

Bisecting goes back to this commit:

2b499381bc50ede01b3d8eab164ca2fad00655f0 is the first bad commit
commit 2b499381bc50ede01b3d8eab164ca2fad00655f0
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue May 3 22:49:52 2011 -0400

    ftrace: Have global_ops store the functions that are to be traced
    
    This is a step towards each ops structure defining its own set
    of functions to trace. As the current code with pid's and such
    are specific to the global_ops, it is restructured to be used
    with the global ops.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

