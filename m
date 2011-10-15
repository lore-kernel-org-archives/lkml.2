Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1JOANy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:13:54 -0400
Received: from lucidpixels.com ([72.73.18.11]:53646 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1JOANx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:13:53 -0400
Date: Fri, 14 Oct 2011 20:13:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 3.1-rc9: IPMI Bug in 3.x++ [kipmi utilizes 100% CPU until ipmitool
 sel clear is issued[
Message-ID: <alpine.DEB.2.02.1110142010580.7699@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel: 3.1-rc9 on x86-64

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  1203 root      39  19     0    0    0 R  100  0.0   3693:29 kipmi0

I have a supermicro board in a non-supermico chassis and it keeps alerting
that there is a chassis intrusion, when it fills up this process goes to
100%, when I run ipmitool sel clear, it goes back to 0-1%.

# ipmitool sel clear

Then--

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  1203 root      39  19     0    0    0 S    0  0.0   3695:26 kipmi0

Would LKML consider this a kernel bug, shouldn't it just discard future
incoming events/and/or treat/handle it differently rather than using 100%
of the CPU?

Justin.

