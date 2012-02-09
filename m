Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2BICp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:45:57 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62681 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565Ab2BICp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:45:56 -0500
MIME-Version: 1.0
Date: Wed, 8 Feb 2012 21:45:55 -0500
Message-ID: <CALKntY2tXfF3UTfL=kvuotDbdfvp2V_WBhs3hx9CaSPEcbfrdg@mail.gmail.com>
Subject: linux thread scheduling
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a program that spawns 3 threads and there is a great deal of
sharing among the three threads. they all read/update a couple of
shared variables.

I run this on nehalem (8 cores, 4 core in each physical package),  I
find that running the 3 threads on core 0, 1, 2 (using
pthread_setaffinitiy) gives much better results, this is because the
cache coherency protocol performs much better on the same package.
However, if  I leave Linux (Suse Enterprise) to schedule it. it gives
much worse performance, i suspect that linux is scheduling the 3
threads across the physical packages ( 2 on one package, 1 on
another). Is this possible ? why does linux do this ?

Thanks

Xin
