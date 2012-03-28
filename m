Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2C1KLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:11:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49898 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab2C1KLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <3A8C969225424C4D8E6BEE65ED8552DA07889037@XMB-BGL-41C.cisco.com>
References: <3A8C969225424C4D8E6BEE65ED8552DA07889037@XMB-BGL-41C.cisco.com>
Date: Wed, 28 Mar 2012 15:41:12 +0530
Message-ID: <CABJk5knEkDvNkpN+Gq1+yPM5pQ0AnBFJR=QNWONZr=uVaSwd0g@mail.gmail.com>
Subject: Re: FW: Kernel: low stack detected by irq handler
From: radiatejava <radiatejava@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an update to this case (note that this kernel module is
trapping every packet entering into the system and processing it as
needed) - recently some functions were added to in the processing path
of the packet to log the packet contents to a log file
(/var/log/messages). Logging functions were all written as 'inline'
functions. We just tried removing the inline keyword from the function
definitions and we are no longer observing the issue of kernel crash
and low stack by irq handler. Can anyone explain to me what is the
impact of having the function inline ? Appreciate your response. In
case the original issue is not visible here, I am putting the link
http://marc.info/?l=linux-kernel&m=131805703608420&w=2

Thanks in advance.

>> Hello experts,
>> I have recently moved from kernel 2.6.18-128 to 2.6.18-194. I have my
>> own kernel module also (click). With the new 2.6.18-194 version of
>> kernel, I am getting this error:
>>
>> Kernel: low stack detected by irq handler
>
> You are using too much stack basically and the kernel is catching this.
> The call trace should let you work out which path through your code is
> the problem.
>
> You've got an IRQ in the middle so it may well be its the combination of
> too much stack being used by the main code paths and an IRQ at just the
> wrong moment causing further high stack usage in the IRQ path that tips
> it over the edge.
