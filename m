Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471Ab1LPXOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:14:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53815 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1LPXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:14:38 -0500
Date: Fri, 16 Dec 2011 17:14:30 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Urban Loesch <bind@enas.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: divide by zero error: find busiest group on kernel 2.6.38.4
Message-ID: <20111216231414.GA7941@BohrerMBP.rgmadvisors.com>
References: <4EDB7CE0.9010105@enas.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDB7CE0.9010105@enas.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 03:00:00PM +0100, Urban Loesch wrote:
> I'm running a DELL PE R610 with kernel
> 2.6.38.4 patched with linux vserver version vs2.3.0.37-rc15 from
> http://linux-vserver.org.
> 
> The server runs fine about 220 days without any problems.
> But last night there was a kernel panic and the server totally hangs.
> 
> Thanks to netconsole I got the following error in my syslogserver:
> 
> 
> 2011-12-04 00:32:16 divide error: 0000 [#1]
> 2011-12-04 00:32:16 SMP
<snip>
> 2011-12-04 00:32:16 Pid: 0, comm: kworker/0:1 Not tainted
> 2.6.38.4-vs2.3.0.37-rc15-rol-em64t #1
> 2011-12-04 00:32:16
> 2011-12-04 00:32:16 Dell Inc. PowerEdge R610
> 2011-12-04 00:32:16 /
> 2011-12-04 00:32:16 0F0XJ6
> 2011-12-04 00:32:16
> 2011-12-04 00:32:16 RIP: 0010:[<ffffffff8103abb8>]
> 2011-12-04 00:32:16 [<ffffffff8103abb8>]
> find_busiest_group+0x428/0xdd0

This looks like the same issue as:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=636797
and
https://bugs.launchpad.net/linux/+bug/614853

In theory there is also a bugzilla.kernel.org ticket on this issue as
well though bugzilla.kernel.org is still down.

https://bugzilla.kernel.org/show_bug.cgi?id=16991

Debian and Ubuntu have papered over this bug by skipping the divide if
cpu_power is 0.

> I searched the archives but I didn't find any related information.
> Have you any idea what this error could be and is it fixed in kernel 3.1?

To my knowledge the cause of this bug is still unknown.  It is
possible it is fixed in newer kernels, but it is hard to tell since it
doesn't seem to occur until you have reached 200+ days of uptime.

--
Shawn
