Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2FPB5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 21:57:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57530 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2FPB5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 21:57:49 -0400
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 15 Jun 2012 21:57:27 -0400
Message-ID: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
Subject: SNB PCI root information
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lenb@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI roots in multi-socket SNB are part of specific sockets.  This
means optimization will need to know which socket the root is part of
and therefore which cores have direct access as opposed to over one or
more QPI links.

I tried to find this information in the /sys filesystem in kernels up
to the current upstream kernel.  It seems there is actually nothing
like this.

There are the files /sys/devices/pci*/*/local_cpus which should
contain this information.  For each device we would be able to get the
information about the local CPUs.

The SPARC OF handling seems to set the field, some Intel drivers seem
to try to do it in a different way.

The problem I have seen (at least on a Dell R620) is that the
dev_to_code() function returns -1 which indicates that no node
information is stored.

If I understand the code correctly, the numa_node field can be set
explicitly but is mostly inherited from the underlying device (bus
etc).  Does this mean that the locality information should come from
the same place where the PCI root data structure is initialized?

This happens, if I'm not mistaken, in the ACPI table parsing.  I've
disassembled the DSDT table and didn't find anything like this type of
information.  At least I didn't see it.  I also couldn't find anything
in the ACPI 5.0 spec.


The questions are:
a) am I missing something?
b) do BIOSes (perhaps from other manufacturers) provide the information?
c) can we get this fixed?
d) can we interpolate the information for platforms where the BIOSes
don't have the information?
