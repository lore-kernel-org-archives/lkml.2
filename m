Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0CQU4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:56:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43821 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0CQU4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:56:02 -0400
Date: Wed, 17 Mar 2010 15:55:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Jiro SEKIBA <jir@dependable-os.net>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Checkpoint-Restart - v19
Message-ID: <20100317205556.GA20750@us.ibm.com>
References: <4B83106C.7040203@cs.columbia.edu>
 <a1c54a921003150155q4a0c7fc1vb02ba0464b07f452@mail.gmail.com>
 <4B9EBAF2.1060304@cs.columbia.edu>
 <0B4E8136-FFC6-490D-B04A-23A6E1A924FF@dependable-os.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0B4E8136-FFC6-490D-B04A-23A6E1A924FF@dependable-os.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jiro SEKIBA (jir@dependable-os.net):
> Hi,
> 
> Thank you for prompt reply!
> Sorry that I didn't post to containers@lists.linux-foundation.org.
> 
> On 2010/03/16, at 7:55, Oren Laadan wrote:
> 
> > Hi,
> > 
> > Thanks for taking the time to evaluate c/r. You may want to also
> > try the latest, which is (as of now) ckpt-v20-rc2.
> 
> Yeah, I'll eventually try to keep up with the latest,
> but I just want to try the one  you think it's stable first anyway.
> 
> > In the future, please CC the containers mailing list for issues
> > related to c/r, at "containers@lists.linux-foundation.org".
> > 
> > Jiro SEKIBA wrote:
> >> Hi,
> >> I'm trying to evaluate external checkpoint/restart with cr-v19 kernel.
> >> However, when I restart, I got "Killed" message in stdout.
> >> Do you have any tips or clue that are not in
> >> Documentation/checkpoint/usage.txt ?
> >> I'm using kernel pulled from
> >> git://git.ncl.cs.columbia.edu/pub/git/linux-cr.git .
> >> checkout tag named "ckpt-v19". Base distro is ubuntu 9.10.
> >> I ran self checkpioint/restart sample program in Documentation/checkpint.
> >> It works as written in usage.txt.
> >> However, I can not make external checkpint/restart work properly.
> >> I made a simple test program bellow and create checkpoint externally using
> >> the program in Documentation/checkpoint/, it looks checkpoint file is
> >> created properly.
> >> However, when I ran self_restart < ckpt.image, I got "Killed" message.
> > 
> > If you take an external checkpoint, then you need to match it
> > with an external restart, as opposed to self_restart.
> > 
> > Otherwise, restarting with self_restart from a checkpoint that is
> > not a self-checkpoint can yield unexpected results.
> > 
> > Since you don't mention in your post, I don't know if you are using
> > the tools from user-cr. If not, then you should use 'checkpoint' and
> > 'restart' tools from there. It is available from:
> > 	git://git.ncl.cs.columbia.edu/pub/git/user-cr.git
> > (use the same branch as the one you used to linux-cr).
> > 
> > Once you have the tools compiled, and you checkpoint with the
> > 'checkpoint' utility from there, you can restart with:
> > 	restart -v < ckpt.image
> > 
> 
> Thank you for the information.
> Actually I was trying to create checkpoint in Document/checkpints.
> 
> Now, I tried with user-cr, compiled binary in the same tag (ckpt-v19).
> Creating checkpoint  looks OK and restart -v shows it Success.  nice!
> However, the contents in /tmp/test.out never get further,
> it remains same as when created checkpoint.
> 
> I tried  "./restart -F /cgroup/0 -v --no-pidns < ckpt.image", got Success.
> cat /cgroup/0/tasks tells that there is a process.
> ps shows ./test.  So, it looks restarting.
> 
> # ps axuww |grep $(cat /cgroup/0/tasks )
> root      7231  0.1  0.0   1588    64 pts/0    D    16:57   0:00 ./test
> root      7238  0.0  0.1   2716   660 pts/1    R+   16:57   0:00 grep 7231
> 
> under the /proc, one file descriptor opened, and it is /tmp/test.out
> 
> #  ls -l /proc/$(cat /cgroup/0/tasks)/fd
> total 0
> lrwx------ 1 root root 64 Mar 16 16:58 0 -> /tmp/test.out
> 
> Nhh, it's close..
> 
> I found that when I mount cgroup with -o freezer, self_checkpoint won't work.
> It worked even I didn't mount the cgroup.
> Is it what you expect?

No, it is not.  Can you tell us more about exactly how it fails?

Maybe get the cr_tests (either from Oren's tree or from
git clone git://git.sr71.net/~hallyn/cr_tests.git), cd cr_test,
make, cd simple, run ./ckpt and send us the contents of
/tmp/log, dmesg, and ckptinfo -ve /tmp/out ?

> Thank you again for the help!
> I'm feeling better to use the latest ..

-serge
