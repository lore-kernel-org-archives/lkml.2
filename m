Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0F2VZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:25:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58293 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0F2VZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xt38N/QLJ7juTEojAuPuLUZngtv/0MbkJn185E2kpk8/AiQtumyDhFIu8c7y+6BFA8
         EYAGiIf6tP2wIvlgfJ+QslwZb3CfiwlJ9hv7N35HSorCnm+jtO6kq9MPymFvj0VfMpP7
         L8sPIVpOktqknG7VWvReii53BKjww2yCIFgR0=
MIME-Version: 1.0
Date: Tue, 29 Jun 2010 17:25:10 -0400
Message-ID: <AANLkTinl3ighc51F5V4YP7fuOSscAA_qcynYMtM5j5wk@mail.gmail.com>
Subject: Hypervisor detection from within a Linux VM
From: Chetan Loke <chetanloke@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       chetanloke@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Requirement:
I have the need to support my apps(running on a Linux VM) on different
*nix hypervisors(ESX/Xen etc). I need to know on which hypervisor my
app is running. I read the CPUID usage thread -
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/22643 but to be
honest in the end I looked at
http://lxr.linux.no/#linux+v2.6.34/arch/x86/kernel/cpu/vmware.c#L88
The vmware_platform() detection code is straight forward.

Current-hack:
As a quick hack we just grep lspci for VMware's pci-ids.

Solution:
I can write a bare minimal driver, check the cpu-id as VMware's
balloon driver does and then emit a proc/sysfs node. The setup
packages and the apps can then check for this node-string.I'm
currently working on ESX and I am hoping that this thin-driver will
work.

Question:
Q1)Is it possible to get this functionality as part of the stock
kernel or is that a bad idea? I suspect there could be other
users/apps who would need to know what *nix hypervisor(or a
non-virtualized environment) they are
running on?
Q2)If this is not the right approach then can someone please suggest
another approach?

Regards
Chetan Loke
