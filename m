Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019Ab0KQVVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:21:35 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:54470 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab0KQVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:21:33 -0500
From: James Cloos <cloos@jhcloos.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <20101116202839.GC27235@tango.0pointer.de> (Lennart Poettering's
	message of "Tue, 16 Nov 2010 21:28:39 +0100")
References: <20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116015648.GA11534@redhat.com>
	<1289916171.5169.117.camel@maggy.simson.net>
	<1289916683.2109.625.camel@laptop>
	<AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	<20101116170312.GA19327@tango.0pointer.de>
	<AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	<20101116181603.GC19327@tango.0pointer.de>
	<AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	<20101116202839.GC27235@tango.0pointer.de>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Wed, 17 Nov 2010 15:59:05 -0500
Message-ID: <m3ipzvacpa.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Hashcash: 1:30:101117:mzxreary@0pointer.de::KRS/q7o5LJlO05yY:000000000000000000000000000000000000000058T4f
X-Hashcash: 1:30:101117:torvalds@linux-foundation.org::6fxW40+8ql4tmOTr:0000000000000000000000000000000AhSo0
X-Hashcash: 1:30:101117:dhaval.giani@gmail.com::9RSWIViKBN1xWJAj:000000000000000000000000000000000000002pPUX
X-Hashcash: 1:30:101117:a.p.zijlstra@chello.nl::+bF7//RdPjGNXfyt:00000000000000000000000000000000000000hnJHv
X-Hashcash: 1:30:101117:efault@gmx.de::mygHhjVU4KccSEwA:000sc+TM
X-Hashcash: 1:30:101117:vgoyal@redhat.com::D6FfBUBHP+1/cPb/:000000000000000000000000000000000000000000044Z0t
X-Hashcash: 1:30:101117:oleg@redhat.com::0ZJPBHWt3A8FMpAg:0Ho2SD
X-Hashcash: 1:30:101117:markus@trippelsdorf.de::55JkGorrvUBfvwIq:00000000000000000000000000000000000000DNFbo
X-Hashcash: 1:30:101117:mathieu.desnoyers@efficios.com::bt44iTAbPF3QyxZZ:000000000000000000000000000000EXQ8o
X-Hashcash: 1:30:101117:mingo@elte.hu::EPLBCoXSZxlEOgnH:000K1dIN
X-Hashcash: 1:30:101117:linux-kernel@vger.kernel.org::Ap9VGA+362Nm6UrZ:00000000000000000000000000000000CvWgo
X-Hashcash: 1:30:101117:balbir@linux.vnet.ibm.com::km7dj3QJgfH0AgVW:00000000000000000000000000000000000G8eE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "LP" == Lennart Poettering <mzxreary@0pointer.de> writes:

LP> Heck, the patch wouldn't even have any effect on my machine (and I am
LP> hacker), because I tend to run my builds from within emacs. And since
LP> emacs has no TTY (since it is a X11/gtk build) it wouldn't be in its own
LP> scheduling group.

M-x compile uses a pty to talk to its sub-process, so if ptys get their
own cgroup then a compile w/in emacs will, too.

(Try using tty as the command M-x compile should run to confirm.)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
