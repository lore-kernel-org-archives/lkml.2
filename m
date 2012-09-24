Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2IXNzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:55:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35739 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2IXNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:55:00 -0400
Date: Mon, 24 Sep 2012 09:43:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.7-rc7-tag
Message-ID: <20120924134343.GA31618@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

I've one fix for which I got the Tested-by right after I sent you a git pull on
Friday. If you have some extra patches for rc7, please consider pulling it.
If you don't have any - I will just stick this in my for-v3.7.

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.6-rc7-tag

It is a bug-fix when we run the initial PV guest on a AMD K8 machine
and have CONFIG_AMD_NUMA enabled and detect the NUMA topology from the Northbridge.

We end up in the situation where the initial domain gets too much information
and gets confused and crashes - the fix is to restrict the domain to get the
information - and we do it by just disabling NUMA on the PV guest (the hypervisor is
still able to do its proper NUMA allocations of guests). It is OK to disable the PV
guest from accessing NUMA data as right now we do not inject any NUMA node information
to the PV guests. When we do get to that point, then this patch will have to be reverted.

Konrad Rzeszutek Wilk (1):
      xen/boot: Disable NUMA for PV guests.

 arch/x86/xen/setup.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
