Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1D2T6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:58:30 -0400
Received: from trent.utfs.org ([194.246.123.103]:53382 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760563Ab1D2T63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:58:29 -0400
Date: Fri, 29 Apr 2011 12:58:26 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110428233751.GR12436@dastard>
Message-ID: <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 at 09:37, Dave Chinner wrote:
> Did you read the email that pointed to CONFIG_TINY_RCU as the
> ptotential source of the problem? Can you change to CONFIG_TREE_RCU
> and see if the problem goes away?

Tried with TREE_RCU, unfortunately the problem persists. However, the OOM 
messages did not make it to the disk this time. Syslog continued to work 
until 11:51 (local time), the slabinfo-8-TREE_RCU.txt file was written to 
until 11:57, the machine was already unusable at that point. At 12:07 I 
took a "screenshot" and then powercycled the machine:

  http://nerdbynature.de/bits/2.6.39-rc4/oom/
  (The files marked with -8 are the current ones)

Btw, the xfs filesystem I'm du'ing over is still mounted with "noatime".

Any ideas? Patches to try?

Thanks,
Christian.
-- 
BOFH excuse #70:

nesting roaches shorted out the ether cable
