Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab1JZQIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:08:16 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:46871 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1JZQIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:08:15 -0400
Message-ID: <1319645292.3321.24.camel@br98xy6r>
Subject: kdump: No udev events for memory hotplug?
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Oct 2011 18:08:12 +0200
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek and Eric,

I noticed that on my system kernel 3.1 *no* udev events for memory
hotplug are generated. Same on my RHEL6.1.

# udevadm monitor
# echo offline > /sys/devices/system/memory/memory4/state

-> No event

But we need the udev events in order to do a kdump reload for setting up
the ELF loads correctly.

In my /etc/udev/rules.d/98-kexec.rules there are rules for memory
hotplug:

SUBSYSTEM=="memory", ACTION=="add", PROGRAM="/etc/init.d/kdump restart"
SUBSYSTEM=="memory", ACTION=="remove", PROGRAM="/etc/init.d/kdump
restart"

Perhaps/probably I am missing something?

Michael


