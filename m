Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2HVM7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:59:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40071 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932335Ab2HVM7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:59:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/MOokJPYjMdoC7/6wuW1t+9Akj2/QFiX1XIBXHci
	sb93NFFaOzQlAs
Message-ID: <1345640356.26849.59.camel@marge.simpson.net>
Subject: x86_64: can boxen lose IPIs during IPI storm?
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Wed, 22 Aug 2012 14:59:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Not so hypothetical situation: CPUs are having a major SCSI induced IPI
fest, printk via serial port is happening while the storm is raging.
Can it happen that while IRQs are disabled, multiple IPIs arrive, thus
losing one or more?  Seems like that possibility _has_ to be excluded by
hardware for SMP to actually work (and it generally does;) but...

I ask because of a dump I saw, where CPU3 waits for CPU1 forever after
having IPId all CPUs, with all except CPU1 having responded.  CPU1,
seemingly unaware of any such IPI, was then used to trigger that very
dump, ie was not busted/stuck, which looked rather like a lost IPI.

-Mike

