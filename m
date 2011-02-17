Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1BQAUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:20:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:33594 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1BQAUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:20:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ryan Underwood <ryan.underwood@flightsafety.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Date: Thu, 17 Feb 2011 00:17:27 +0000 (UTC)
Message-ID: <loom.20110217T003826-785@post.gmane.org>
References: <9F0C2539CB50A743894F8FCEEB1D569206F4A5@mx1.guavus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 66.109.95.8 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.6) Gecko/2009011913 Firefox/3.0.6 (.NET CLR 3.5.30729))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preeti Khurana <Preeti.Khurana <at> guavus.com> writes:

> 
> I am getting the similar issue as reported
> in https://lkml.org/lkml/2011/2/10/187
> 
> Can someone tell me if the same issue  because I am getting the
> problem on Intel Xeon..
> 

I am seeing exactly the same problem (on 2.6.35 as Preeti reported originally)
on some Xeon servers but only with recently shipped BIOS revisions. The OS is
CentOS 5.5.

In my cases, the system sometimes hangs with no comment, sometimes with a NMI
message immediately before hanging and sometimes with a long trail of
backtrace originating at cpu_idle().  The NMI reason code is different but
in my observation it is usually 21 or 31.

The problem seems to be triggered by accessing a PCI card (via MMIO) because 
until accessing the PCI card, the system will run forever with no problems.

Other servers of exactly the same model (Intel SR2500) but older BIOS revision
are working (working is 3/14/2008, non working is 3/9/2010).  All software is
identical in these cases.

Also, in one instance, kernel v2.6.18 is used on these servers with the
3/14/2008 BIOS revision without a problem.  The rest of the software is again
the same (except for kernel and drivers).

It seems to be a problem with newer kernels combined with the newer Intel BIOS.
I have not tried an older kernel on the newer BIOS yet.

I have not tried the following patches yet which seem to both be for spurious
NMI messages, not accompanied by system lockups:

https://lkml.org/lkml/2011/2/16/106
https://lkml.org/lkml/2011/2/1/286

Both nmi_watchdog=0 and pcie_aspm=off options do not solve the problem.

I am not subscribed so please Cc me.

