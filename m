Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0HUP7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 11:59:06 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:52152 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab0HUP7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 11:59:05 -0400
Message-ID: <1282406337.4c6ff7c1533ad@imp.free.fr>
Date: Sat, 21 Aug 2010 17:58:57 +0200
From: castet.matthieu@free.fr
To: linux-kernel@vger.kernel.org
Subject: is VM_GROWSDOWN still useful
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 81.57.151.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering if the flags GROWSDOWN/GROWSUP is still useful on linux today. It
is only used for the main thread stack.
Stack allocated by pthread doesn't use anymore GROWSDOWN because you can't
guaranty that a user mapping (via mmap) will collide with it.

Why not doing the same for the main thread : allocate a stack of the rlimit size
?

Linux memory allocation use over-commit, and physical memory will only be
allocated when the stack is really used.

Or are they real usage of GROWSDOWN ?

Matthieu
