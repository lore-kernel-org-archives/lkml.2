Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab1LFMfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:35:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:34360 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327Ab1LFMfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:35:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Steven Seagull <steven7779@gmx.net>
Subject: possible causes for EADDRINUSE in client code
Date: Tue, 6 Dec 2011 12:11:26 +0000 (UTC)
Message-ID: <jbl0pd$g9q$1@dough.gmane.org>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: tor.foldr.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm running a 2.6.26 kernel where I have to create short-lived TCP
connections with a high frequency. In order to do this, I am using
non-blocking sockets which are bound to different IP addresses in a
round-robin manner, and to port 0, so the kernel can choose a free
local port.

Now I observed that I am getting EADDRINUSE errors on the bind system
call, even though there should be ports left according to the current
net.ipv4.ip_local_port_range sysctl setting.

I tried to enumerate the used ports at the time of the error using
netstat, which shows only rather few ports being in use, but I
realize that this is an inaccurate measure because it takes time for
netstat to be forked and run.

What I wonder is: Is there any limit beyond
net.ipv4.ip_local_port_range which may lead to EADDRINUSE errors?
Maybe any limits in the kernel data structures I should be aware of
when working with huge amounts of TCP connections?

Thanks!

--
Steven

