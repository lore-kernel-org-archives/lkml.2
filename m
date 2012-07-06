Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2GFG1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:27:46 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:43760 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2GFG1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:27:45 -0400
Message-Id: <4FF6A17B020000A10000A5E8@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 08:27:39 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: /sys and access(2): Correctly implemented?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Recently I found a problem with the command (kernel 3.0.34-0.7-default from SLES 11 SP2, run as root):
test -r "$file" && cat "$file"
emitting "Permission denied"

Investigating, I found that "test" actually uses "access()" to check for permissions. Unfortunately there are some files in /sys that have "write-only" permission bits set (e.g. /sys/devices/system/cpu/probe).

~ # ll /sys/devices/system/cpu/probe
--w------- 1 root root 4096 Jun 29 12:43 /sys/devices/system/cpu/probe
~ # F=/sys/devices/system/cpu/probe
~ # test "$F" && cat "$F"
cat: /sys/devices/system/cpu/probe: Permission denied

In times of capabilities and ACLs, shouldn't there be a test for permissions that actually works?

Regards,
Ulrich
P.S. Please make sure my CC: gets your replies, too -- thanks

