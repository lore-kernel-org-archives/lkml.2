Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1ASXxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:53:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37478 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1ASXxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:53:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 20 Jan 2011 00:53:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: section mismatch in intel_idle
Message-ID: <20110120005329.24119041@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this just showed up in 2.6.38-rc1:

WARNING: drivers/idle/built-in.o(.text+0x112): Section mismatch in reference from the function intel_idle_probe() to the variable .cpuinit.data:setup_broadcast_notifier
The function intel_idle_probe() references
the variable __cpuinitdata setup_broadcast_notifier.
This is often because intel_idle_probe lacks a __cpuinitdata 
annotation or the annotation of setup_broadcast_notifier is wrong.

WARNING: drivers/idle/built-in.o(.exit.text+0x2d): Section mismatch in reference from the function intel_idle_exit() to the variable .cpuinit.data:setup_broadcast_notifier
The function __exit intel_idle_exit() references
a variable __cpuinitdata setup_broadcast_notifier.
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __cpuinitdata annotation of
setup_broadcast_notifier so it may be used outside an init section.

-- 
Stefan Richter
-=====-==-== ---= =-=--
http://arcgraph.de/sr/
