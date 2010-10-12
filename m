Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab0JLR37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:29:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0JLR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=LU2CCTUO10vaqb+AvUYowsq4vx65BhgYXN84zcV0qBG8sECHbeoDbEjY+OrDJqOv9z
         H3NfClBYYjRTaZRj7hhQ==
MIME-Version: 1.0
Date: Tue, 12 Oct 2010 10:29:54 -0700
Message-ID: <AANLkTinQAwEMGADYXX=2Rt3RUoMozDReNdpo9NtV1OO7@mail.gmail.com>
Subject: [ANNOUNCE] Linsched for 2.6.35 released
From: Ranjit Manomohan <ranjitm@google.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Nikhil Rao <ncrao@google.com>,
        Salman Qazi <sqazi@google.com>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I would like to announce the availability of the Linux Scheduler Simulator
(Linsched) for 2.6.35.

Originally developed at the University of North Carolina, LinSched is a
user-space program that hosts the Linux scheduling subsystem.
Its purpose is to provide a tool for observing and modifying the behavior
of the Linux scheduler. This makes it a valuable tool in prototyping new
Linux scheduling policies in a way that may be easier (or otherwise
less painful or time-consuming) to many developers when compared
to working with real hardware.

Since Linsched allows arbitrary hardware topologies to be modeled,
it enables testing of scheduler changes on hardware that may not be
easily accessible to the developer. For example, most developers don't
have access to a quad-core quad-socket box, but they can use LinSched
to see how their changes affect the scheduler on such boxes.

When compared to alternatives such as using UML which may offer
similar benefits to developers, Linsched has fewer dependencies and
relies on a very small subset of files of the kernel. It also offers stable
and repeatable results that are not affected by the environment or
hardware that is used to run the simulation.

LinSched may be especially useful to those who are new to Linux
scheduler development since it brings all the benefits of user space
analysis and debugging tools (e.g. gdb) to understanding the
kernel scheduler code.

The code is available at:

http://google3-2.osuosl.org/?p=linsched/2.6.35.git;a=summary

You can clone the repository using:

git clone git://google3-2.osuosl.org/linsched/2.6.35.git

New features/functionality in this release are:
-- Based on the 2.6.35 kernel
-- support for group scheduling
-- Ability to specify arbitrary sleep/wakeup patterns for tasks
-- High resolution timers
-- Tickless scheduler (no hz)
-- sched domain support for all levels

At Google we have used Linsched as a testing tool to validate the
behavior of the kernel scheduler. Please see some of the basic tests
we have added at linsched/basic_tests.c. We could  cut down our
validation time from several days to a couple of hours due to the ability
to run multiple tests on several different types of hardware models.

Recently we have proposed a set of enhancements to the CFS scheduler
including:
 -- CFS bandwidth control
   (http://thread.gmane.org/gmane.linux.kernel/979066)
 -- Improved load balancing for low weight tasks
   (http://thread.gmane.org/gmane.linux.kernel/1041721)
These features have been extensively validated using this new infrastructure
which has helped weed out some bugs that would have been difficult to catch
otherwise. See http://thread.gmane.org/gmane.linux.kernel/1037521 for an
example of a load balancing bug uncovered during testing.

We are working on a port of Linsched to 2.6.36 and I would encourage folks
experimenting with the kernel scheduler to give it a try. Please see the
instructions specified in the linsched/README file to build and run tests.

-Please contact me if you run into any difficulties or have any questions

-Thanks,
-Ranjit Manomohan
