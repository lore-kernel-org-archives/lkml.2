Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1EQQ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:28:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59824 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1EQQ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cziWW7ND+SdscPcZtJ96cEHzJhMGObg0NbCPN72MYSEz/pdCLfZ9JhKTmDIfhQSafB
         ZpzZDy/X5IDvJpK1HHWX27+kbydE1iOIU7kqTv8TQDulkNTxfhqhcJm4+10t2FT0IEay
         jQEJwDZ8t+MY/O0Ti+S2sdZQGgvRh3KhpFZbA=
Date: Tue, 17 May 2011 18:28:27 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: powerpc: mpc85xx regression since 2.6.39-rc2, one cpu core lame
Message-ID: <20110517162827.GA16918@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

Recent 2.6.39-rc kernels behave strangely on the Freescale dual core
mpc8572 and p2020. There is a long pause (like 2 seconds) in the boot
sequence after "mpic: requesting IPIs..."

When the system comes up, only one core shows in /proc/cpuinfo. Later
on, lots of messages appear like the following:

   INFO: task ksoftirqd/1:9 blocked for more than 120 seconds.

I bisected [1] the problem to:

   commit c56e58537d504706954a06570b4034c04e5b7500
   Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
   Date:   Tue Mar 8 14:40:04 2011 +1100

       powerpc/smp: Create idle threads on demand and properly reset them

I don't see from that commit what had gone wrong. Perhaps you can
help resolve this?

Thanks,
Richard


1. I had to patch commit e5462d16 by hand when bisecting, which is a
   fixup for commit fa3f82c8 and not yet merged in c56e5853.
