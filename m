Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab0I2Oq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab0I2Oq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:46:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        oleg@redhat.com
Subject: [PATCHv2 0/2] oprofile, x86: allow backtrace for 32bit apps under 64bit kernel
Date: Wed, 29 Sep 2010 16:46:45 +0200
Message-Id: <1285771607-12089-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm sending reworked version of the support for backtrace of ia32
applications under 64bit kernels.

updates are based on comments by Robert Richter

v2:
	- using struct stack_frame for 64bit processes
	- using struct stack_frame_ia32 for compat processes
	- added inline function x86_backtrace_32 which is
	  just empty stub for !CONFIG_COMPAT
	- I did not figure out a smart way to share dump code between
	  32 and 64 bits. I'm currently under impression the code is
	  so far easy and light enough to live separately and mixing
	  the code would come with more complexity.


attached patches:
- 1/2 using struct stack_frame for 64bit processes dump
- 2/2 adding backtrace dump for 32bit process in compat mode

please let me know what you think

thanks,
jirka
---
 arch/x86/oprofile/backtrace.c |   70 ++++++++++++++++++++++++++++++++++------
 1 files changed, 59 insertions(+), 11 deletions(-)
