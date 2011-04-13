Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab1DMTuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:50:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:36932 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170Ab1DMTuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:50:10 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Subject: gcc-4.6.0 generates no code for sub_preempt_count()
Date: Wed, 13 Apr 2011 21:50:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104132150.05623.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm facing a very strange issue with gcc-4.6.0 and UML.
Within __local_bh_enable() gcc generates no code for sub_preempt_count().

See:
http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc460.txt
vs.
http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc431.txt

Interestingly it generates code for add_preempt_count().
I can reproduce this on x86 and x86_64.

The problem has to do with UML's current_thread_info() function.
When I replace it with arch/x86's (unportable) variant gcc generates code.

Any ideas whether this is a gcc or a kernel issue?
Thanks,
//richard
