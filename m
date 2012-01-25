Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2AYAEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:04:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab2AYAEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:04:40 -0500
Date: Tue, 24 Jan 2012 19:04:34 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120125000434.GC13655@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a report [1] from users booting the 3.2.1 kernel and getting a
large number of KERN_ERR messages that look like:

[    0.020902] Unable to reset IRR for apic: 2, pin :0
[    0.020970] Unable to reset IRR for apic: 2, pin :1
[    0.021012] Unable to reset IRR for apic: 2, pin :2
[    0.021077] Unable to reset IRR for apic: 2, pin :3
[    0.021138] Unable to reset IRR for apic: 2, pin :4
[    0.021199] Unable to reset IRR for apic: 2, pin :5
[    0.021261] Unable to reset IRR for apic: 2, pin :6
[    0.021323] Unable to reset IRR for apic: 2, pin :7

Digging through git, it seems that error message was added to 3.2 with
commit 1e75b31d63.  The commit log mentions kdump, but I don't believe the
user is doing kexec/kdump of any kind.  It seems a normal yum update/reboot
and they hit this.

Are there any details the user can gather to help debug this, or has
anyone seen this before?

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=784445
