Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0FYVtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:49:10 -0400
Received: from mail.globaldataguard.com ([67.210.231.115]:53930 "EHLO
	mail2.globaldataguard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0FYVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:49:08 -0400
Message-ID: <4C2524D3.9070509@globaldataguard.com>
Date: Fri, 25 Jun 2010 16:51:15 -0500
From: Kurt Newman <knewman@globaldataguard.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32.1 kernel unable to use more than 2 of 16 CPUs on Intel
 E5540 (i7)
References: <4C23D1E9.9050007@globaldataguard.com> <adahbksqe71.fsf@roland-alpha.cisco.com>
In-Reply-To: <adahbksqe71.fsf@roland-alpha.cisco.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=96242FB1;
	url=http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x96242FB1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Your config seems to have CONFIG_PM and therefore CONFIG_ACPI disabled.
> So the kernel is relying on mptable information.  Unsurprisingly on a
> modern system, that info is probably broken -- since everything would
> have been tested with ACPI.
> 
> Try turning on CONFIG_ACPI and see if that helps at all.

Turning on ACPI solved the problem.  I don't understand why ACPI needs
to be turned on, but after reading the power management ldp it confirms
what you said.  I just didn't think that this would have mattered.

Thanks for the help,
Kurt



For anyone else with this problem, here's something to read:

Some SMP system manufacturers may have omitted the pre-ACPI tables used
for SMP configurations. In this case, ACPI is required.

If you have a newer system that supports Hyper-Threading, you will need
to enable ACPI (and, of course, SMP). Without it, your Linux system may
be unable to discover and initialize all of the virtual processors.

IA64 machines require ACPI as well. Additionally, NUMA servers are
starting to require it for proper initialization.

Source: http://tldp.org/HOWTO/Battery-Powered/powermgm.html#HYPERTHREAD
