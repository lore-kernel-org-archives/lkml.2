Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1AUSUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:20:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52518 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1AUSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:mime-version;
        b=KTn0c+tLw3roFbqE19ElwaiEU9n3Nid4oAx7U0T18Pk85YkEbjHpXlNJ4L8cLkKSeA
         t9kaiJABVjBSai5NbI6qByToqg/Sq1xRW+6biagBfsjYN9O/RGHf6udjCO7LyWVfjafQ
         UZqQED8DCuINiWPACbIjFIcpzdYtNjjcxw5eU=
Message-ID: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
Date: Fri, 21 Jan 2011 10:20:08 -0800 (PST)
Subject: 'autogroup' sched code KILLING responsiveness
From: Michael Witten <mfwitten@gmail.com>
To: linux-kernel@vger.kernel.org
MIME-version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bisecting shows that this commit:

  5091faa449ee0b7d73bc296a93bca9540fc51d0a
  sched: Add 'autogroup' scheduling feature: automated per session task groups
  Date:   Tue Nov 30 14:18:03 2010 +0100

is the reason that my computer has become unusable.

With that code in place, a resource-intensive activity (such as
compiling the Linux kernel) causes my computer to become
unresponsive for many seconds at a time; the entire screen
does not refresh, typed keys are dropped or are handled very
late, etc (even in Linux's plain virtual consoles).

I'm using a uniprocessor (UP) machine, and I've noticed that such
codepaths often get clobbered by changes that only make it to SMP
configurations (I guess kernel hackers have better equipment than
I do); maybe that has something to do with it.

I'm a laymen, so all I can do at this time is report my experience;
if this has already been discussed, I would appeciate a link to
the right thread.

Sincerely,
Michael Witten
