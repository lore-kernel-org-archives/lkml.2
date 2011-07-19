Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1GSUi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:38:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1GSUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:38:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=Zh/hZ8LMRxLyQ6rKs7vbzGDpwa8HNh6wPsVJWWtdf8L7v/s8Gn5+lq+i/W1n6E+bp
	vP/p7pGWy1fS7Y4XaYPTg==
Subject: [PATCH v1 0/2] Support dropping of capabilities from early userspace.
To: "Andrew G. Morgan" <agm@google.com>, Maximilian Attems <max@stro.at>,
        Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
From: Mike Waychison <mikew@google.com>
Cc: Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Jul 2011 13:38:43 -0700
Message-ID: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to klibc mainline.  As is it will probably collide
with Maximilian's recent patch to rename run-init to switch_root posted
last week.



To boot an untrusted environment with certain capabilities locked out,
we'd like to be able to drop the capabilities up front from early
userspace, before we actually transition onto the root volume.

This patchset implements this by adding a "drop capabilities" ability to
both kinit and run-init in the klibc package.  For kinit, it now
understands a new kernel command line option, "drop_capabilities" that
specifies a comma separated list of capability names that should be
dropped right before execing the next init binary on the next root
device.

run-init also has the ability to use this drop_capabilities function by
specifying capabilities that should be dropped with a new command line
flag, '-d'.

Given that this patchset is meant to help secure boots, we treat any
errors as total failure to boot by exiting the process with a failing
exit code.

Thanks,

Mike Waychison

Related discussions
===================
    - Thread discussing my wanting to compile out kernel interfaces that
      we do not want to expose to the userspace environment, with Alan
      Cox convincing me that I really just want to disable certain
      capabilities:

      https://lkml.org/lkml/2011/7/15/412

Patchset summary
================

syscalls: Add capset and capget
run-init: Add drop_capabilities support.
