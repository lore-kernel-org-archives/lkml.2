Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1DERPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1DERPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:15:51 -0400
Message-ID: <4D9B4E3A.4090601@redhat.com>
Date: Tue, 05 Apr 2011 13:15:38 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Don Zickus <dzickus@redhat.com>, mikew@google.com,
        Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: /sys/firmware/dmi name change?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 948af1f0bbc8526448e8cbe3f8d3bf211bdf5181 (and follow on commits)
introduced a new firmware directory called /sys/firmware/dmi which
provides broken out SMBIOS entries for userspace.

In a previous discussion I've mentioned that it would be a good idea for
us to move away from using 'dmi' towards using 'smbios' and centralizing
the SMBIOS code that is scattered throughout the kernel.  One of my
changes was to export the SMBIOS information in a similar way that Mike
did in drivers/firmware/dmi-sysfs.c.

Since this API is new for 2.6.39, can we change the name of the
directory to /sys/firmware/smbios?  Otherwise in 2.6.40, when further
changes are introduced to use SMBIOS in the kernel we will have to
change something that has been stable for one release.

Mike?  Greg?  Alan?  What do you think?  IIUC, the interface isn't yet
"stable" so it should be changed now, correct?

The patch would be trivial ... (no patch attached yet ;) ).

P.
