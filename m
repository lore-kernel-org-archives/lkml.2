Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab1LTNOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:14:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42099 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1LTNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:14:39 -0500
MIME-Version: 1.0
Date: Tue, 20 Dec 2011 13:14:38 +0000
Message-ID: <CABdF1a-UZ8uRjcoJ181_6VjW-iUCa-SY5A1ayr-1gZ45t27Ncw@mail.gmail.com>
Subject: Jiffies counter stalled for minutes and then jumps forwards
From: Robert Whitton <bob91966@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is aimed at the "timing Gods" of the Linux kernel - I
really hope you can help.

I have a very rare time related problem that on a given system only
occurs about once every few years. However, we have a lot of systems
and hence this is more than a weekly occurrence. Each occurrence
causes a watchdog to reset the system which is bad!

Environment:

We are running a Debian kernel 2.6.26-2-amd64 on a TYAN S5211
motherboard that is fitted with an E8400 dual core CPU. The problem
mainly occurs when the system is under heavy load. Due to code that
isn't SMP safe the vast majority of the load is locked to CPU1 whilst
CPU0 is mostly idle.

Problem Description

Calls to "select" (with a timeout) and other similar user mode
functions that are sitting on the jiffies timer are timing out (much)
too late and then subsequently (much) too early. We have added code to
the kernel in the form of a loadable module that on a regular
interrupt compares jiffies to the TSC. The test code confirms that
when the problem occurs the jiffies counter has stalled whilst the TSC
continues to increase monotonically. At the end of the stall the
jiffies counter jumps forwards to the correct time apparently in a
single step. The "stall" periods are not short. They typically extend
for minutes.

Are these symptoms recognised by anyone and if so has the issue been
fixed in a later kernel?

Unfortunately due to the rarity of the issue on a given system and due
to the location of the systems I'm not in a position to be able to
upgrade the kernel on enough systems to be able to test if this is
fixed in a newer kernel within a reasonable time frame.

A few commits have tweaked my interest but I can't obviously see that
any of them exactly match the symptoms that we're seeing.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=b8f8c3cf0a4ac0632ec3f0e15e9dc0c29de917af
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=857f3fd7a496ddf4329345af65a4a2b16dd25fe8
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=02ff375590ac4140d88afc76505df1ad45c6af59

Please CC me in on any replies.

Thanks in advance for any help.

Rob
