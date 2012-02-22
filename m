Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2BVBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:16:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab2BVBQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:16:57 -0500
Date: Tue, 21 Feb 2012 20:16:53 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
Message-ID: <20120222011652.GE23186@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Over in Fedora land, I applied your patch from this thread:

https://lkml.org/lkml/2012/1/24/441

to our 3.3-rc3/rc4 based rawhide kernels.  The intention was to solve an
RCU issue that was very similar to what Eric originally reported, and
the RCU splat did indeed go away[1].

However, we then got a few reports of kernels containing that patch
being extremely slow.  When the patch was dropped, the slowness goes
away according to one reporter.  The details can be found in this bug:

https://bugzilla.redhat.com/show_bug.cgi?id=795050

The slowness doesn't seem to hit everyone, and in my local testing
things seem to be working just fine.  The reporters have widely varying
hardware as well, so it doesn't seem machine specific.

Perhaps I misdiagnosed the original issue, or perhaps I missed something
else that needs to be applied prior to this but I thought I would point
this out in case you had any ideas.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=789641
