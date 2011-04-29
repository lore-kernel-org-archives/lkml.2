Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab1D2Rca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:32:30 -0400
Received: from trent.utfs.org ([194.246.123.103]:56873 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab1D2Rc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:32:29 -0400
Date: Fri, 29 Apr 2011 10:32:16 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110428233751.GR12436@dastard>
Message-ID: <alpine.DEB.2.01.1104291029500.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 at 09:37, Dave Chinner wrote:
> Did you read the email that pointed to CONFIG_TINY_RCU as the
> ptotential source of the problem? Can you change to CONFIG_TREE_RCU
> and see if the problem goes away?

For that I had to select SMP on this UP-PowerPC G4 machine. But compiling 
-rc5 (as the bug is strill present in -rc5) fails with:

/usr/local/src/linux-2.6-git/arch/powerpc/kernel/crash.c: In function 
‘default_machine_crash_shutdown’:
/usr/local/src/linux-2.6-git/arch/powerpc/kernel/crash.c:349: error: 
implicit declaration of function ‘crash_kexec_wait_realmode’
make[2]: *** [arch/powerpc/kernel/crash.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2
make: *** [sub-make] Error 2

Maybe I'll just disable kexec and see if TREE_RCU helps.

Meanwhile, I gave up on the git bisect, as I can hardly boot inbetween 
commits: http://nerdbynature.de/bits/2.6.39-rc4/oom/git-bisect-log.txt

Thanks,
Christian.
-- 
BOFH excuse #446:

Mailer-daemon is busy burning your message in hell.
