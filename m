Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1JNUjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:39:06 -0400
Received: from bues.ch ([80.190.117.144]:44217 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1JNUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:39:05 -0400
Date: Fri, 14 Oct 2011 22:38:07 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Huge amount of randomness with cuse and "urandompar"
Message-ID: <20111014223807.46b27038@milhouse>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

from time to time I need huge amounts of reasonably strong random
data. I want to use /dev/urandom for this, as it seems to have received
enough testing and has various good sources of entropy and good
support by tools such as rngd.

However, /dev/urandom does not seem to benefit at all from multicore systems.
Large parts of the urandom read-codepath in the kernel seem to be completely
lockless, though. So my basic idea was to throw a lot of reader threads at it
while preserving the convenient character device interface. Which lead
to this proof-of-concept CUSE project:

http://bues.ch/gitweb?p=urandompar.git;a=summary
git://git.bues.ch/urandompar.git

So from a first look it doesn't seem too bad, performance wise.
It seems that it currently scales well enough up to 4 CPUs.
Here's a simple chart of a trivial benchmark on a 6-core CPU:
http://bues.ch/misc/urandomparscale.pdf

I didn't profile it with oprofile, yet, but my guess is that it
runs more and more into entropy_store spinlock contention with >4 CPUs.
This has to be verified, though.

An open question still is: What are the implications on the data quality?
Does this massive parallelism affect the urandom algorithms in any way?

Can the bottleneck, that prevents it from scaling properly, be fixed?

Searching for testers, comments and answers. :)

-- 
Greetings, Michael.
