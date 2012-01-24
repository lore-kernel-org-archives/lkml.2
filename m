Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2AXQpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:45:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50577 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2AXQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:45:19 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=1WUCDaJ4X04A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=SG1-INwkJVZbZwXjC5UA:9 a=JDmNLeM2MghZ9mfk-gwA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327423516.22710.31.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] New stable 3.0-rt-rebase branch at
 git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Clark Williams <clark@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Tue, 24 Jan 2012 11:45:16 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because people have complained that there's no more broken out patches
of the stable -rt tree (even though all commits are publicly available
in git), I have decided to create a "rebase" branch. This branch will
contain all the commits for the preempt-rt stable tree based on the last
mainline stable release.

The v3.0-rt branch will never rebase, and should be what users develop
git repositories with.

The v3.0-rt-rebase branch is a branch that will rebase at every version,
and should *not* be used by other developmental git repositories. This
branch will allow you to pull out the commits that will apply to the
stable tree.

At each version, the rebase branch will be tagged with a "-rebase" name
after it.

$ git tag | grep -- -rt
v3.0.10-rt27
v3.0.10-rt27-rebase
v3.0.11-rt28
v3.0.11-rt28-rebase
v3.0.12-rt29
v3.0.12-rt29-rebase
v3.0.12-rt30
v3.0.12-rt30-rebase
v3.0.14-rt31
v3.0.14-rt31-rebase
v3.0.14-rt32
v3.0.14-rt32-rebase
v3.0.17-rt33
v3.0.17-rt33-rebase
v3.0.9-rt25
v3.0.9-rt26


As the 3.0 stable git tree started with 3.0.9-rt25, there was no need to
create a rebase version for that branch.  All rebase tagged commits will
equal their non-rebase counter part using git diff, but the commit IDs
will not be the same.

$ git diff v3.0.17-rt33 v3.0.17-rt33-rebase

The above will show no differences.

To create a quilt queue, simply do the following in your git repo:


$ cd linux-rt-stable.git
$ git checkout v3.0.17-rt33-rebase
$ mkdir patches
$ git format-patch -o patches v3.0.17
$ ls patches > series
$ mv series patches

Now the patches directory will be a quilt queue of the broken out
3.0.17-rt33 patches.

IMPORTANT NOTE: The rebase branch and tags are very low priority. If it
becomes too time consuming to maintain, I *will* stop adding them. They
will be created when I have time to do so. This rebase branch is a
convenience for people that may want it. It may be discontinued at any
time without notice!

-- Steve



