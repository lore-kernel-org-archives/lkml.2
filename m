Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1JCJaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:30:21 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53393 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1JCJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:30:18 -0400
Message-ID: <4E8980A6.8000905@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 15:00:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] Allow for stack traces to be printed on serial console
References: <CAG1a4rtrh7=+gr=kUGO6y4wt926F8rBusOcFgvu4CmvrmR5PCw@mail.gmail.com> <1317358146.9597.11.camel@PavelComp>
In-Reply-To: <1317358146.9597.11.camel@PavelComp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 10:19 AM, Pavel Ivanov wrote:
> When I tried to chase some mysterious lockup of my PC the only means to
> see some error reports for me was serial console. But it looks like only
> printk with KERN_ERR is sent to serial console. So when hung task
> detector tried to show me stack traces for hung tasks I didn't see them
> on serial console and I didn't see them after reboot as they couldn't be
> saved to dmesg. Thus the following patch allowed me to actually see
> those stack traces.

Which kernel messages gets displayed on your serial console is controlled by
your system configuration which can be altered by modifying /etc/rsyslog.conf
or /etc/sysconfig/syslog.conf 
There you can specify that you want to print every kernel message by specifying
kern.* for example.

There are also some kernel command line options you can use to specify which 
level of kernel messages you want to get displayed.

Since you clearly have a system configuration problem here, you don't need to alter the
kernel source to print with KERN_ERR everywhere. Doing that would also defeat the very
purpose of having that nice distinction between informational messages, error messages
and so on, isn't it?

> I believe kernel prints stack traces only in some serious cases and
> expects that they would be actually seen, so KERN_ERR looks justified
> for me in all changed places. I understand that patch is incomplete and
> would need some other places to be changed for consistency (at least
> other arch code). But first I want to hear comments on whether this
> approach is good enough to be included in mainline or it should be left
> for me as a hack.
> 
-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
