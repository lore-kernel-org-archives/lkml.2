Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1AEQLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:11:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1AEQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:11:30 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=yROP_W3SK74A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=b8VgSBC0AAAA:8 a=gu6fZOg2AAAA:8 a=VwQbUJbxAAAA:8 a=lIhnXGrK0jgd6wsSra4A:9 a=7eVaw7ikOrsE3iB1GysA:7 a=cJntZjWMEhnS80r4aj3j5OMeWPsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL] Add ktest.pl to tools/testing/ktest
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, lmr <lmr@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 11:11:27 -0500
Message-ID: <1294243887.26623.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus (et. al.)

As I announced at Kernel Summit, I created a simple kernel test program
that allows a developer to test their kernels with various randconfigs.

It also performs automated git bisects, and serial patch testing.

It can even do a config bisect, which I've used several times to find
that one config that breaks the kernel.

Each of these tests have three kinds of test types:

1) build - This is the simplest of the tests. It just makes sure that
the kernel compiles without error.

2) boot - This not only builds the kernel, but also makes sure that the
kernel boots. You need to have a way to read the console via stdout,
which the tool checks to see if you make it to a login prompt (or
something else if you change the config file).

3) test - This builds, and boots the kernel, and on success of booting,
it will execute some command. You could do a 'ssh host ...' to remotely
kick off a test. It can be any shell script that must exit with 0 on
success and non zero on error.

It comes with a very documented sample config file and a test (for me)
that makes sure all the options in ktest.pl exist also in the sample
config file, so I do not forget to document any new features.

Most of the configs have defaults that you do not need to worry about. I
could add lots of small sample configs for people to start with too.

Anyway, a lot of people asked me to push this into the kernel, so I'm
posting my pull request now. I've kept the history of the development in
the git tree. I'm not posting all the patches as I'm not sure people
care about them. Below is the diffstat and change log. For the final
result of ktest.pl your can see these files:

http://rostedt.homelinux.com/ktest/ktest.pl
http://rostedt.homelinux.com/ktest/sample.conf
http://rostedt.homelinux.com/ktest/compare-ktest-sample.pl

The previous announcement can be found here:

http://marc.info/?l=linux-kernel&m=128925992719659&w=2

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-ktest.git

    branch: master


Steven Rostedt (30):
      Initial start of ktest.pl
      ktest: New features: noclean, dodie, poweroff on error and success
      ktest: New features reboot on error, make options
      ktest: Bisecting, install modules, add logging
      ktest: Added better console, add test build
      ktest: Added reboot on success
      ktest: Added patchcheck
      ktest: Add reverse bisect, better logging, copyright
      ktest: Added continuing on success, clear log and timeout
      ktest: Add open and close console and start stop monitor
      ktest: Added sample.conf, new %default option format
      ktest: Add POST_INSTALL to allow initrds to be created
      ktest: Add poweroff after halt and powercycle after reboot
      ktest: New TEST_START instead of using [], and use real SHA1s
      ktest: Update the sample config file with more documentation
      ktest: Use oldnoconfig instead of yes command
      ktest: Write to stdout if no log file is given
      ktest: Use $output_config instead of typing $outputdir/.config
      ktest: Allow a test case to undefine a default value
      ktest: Output something easy to parse for failure or success
      ktest/cleanups: Added version 0.2, ssh as options
      ktest: Added config_bisect test type
      ktest: Added compare script to test ktest.pl to sample.conf
      ktest: Updated the sample.conf for the latest options
      ktest: Use different temp config name for minconfig
      ktest: Parse off the directory name in useconfig for failures
      ktest: Added force stop after success and failure
      ktest: For grub reboot, use run_ssh instead of run_command
      ktest: Copy the last good and bad configs in config_bisect
      ktest: Ask for the manditory config options instead of just failing

----
 tools/testing/ktest/compare-ktest-sample.pl |   30 +
 tools/testing/ktest/ktest.pl                | 2023 +++++++++++++++++++++++++++
 tools/testing/ktest/sample.conf             |  622 ++++++++
 3 files changed, 2675 insertions(+), 0 deletions(-)


