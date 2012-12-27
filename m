Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2L0Pqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 10:46:45 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39974 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2L0Pql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:46:41 -0500
Message-ID: <50DC6D5D.30806@lwfinger.net>
Date: Thu, 27 Dec 2012 09:46:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
References: <Pine.LNX.4.44L0.1212262251280.25450-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1212262251280.25450-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 09:56 PM, Alan Stern wrote:
> This looks like a matter of getting modules to load in the right order.
> Apparently your OHCI controller doesn't work right if the EHCI driver
> isn't present.  Before the troublesome commit, this meant ehci-hcd had
> to be loaded before ohci-hcd.  Now it means ehci-hcd and ehci-pci both
> have to be loaded before ohci-hcd.
>
> In the dmesg log you provided, ehci-hcd was loaded before ohci-hcd but
> ehci-pci was loaded after.  Of course, when everything is built into
> the kernel (not as modules) then questions of loading order don't
> arise.
>
> You can test this hypothesis by booting a kernel without that commit
> and blacklisting ehci-hcd, so that it doesn't get loaded automatically.
> See if the errors start to come, and see if they stop when you load
> ehci-hcd manually.

I could not do exactly the experiment that you wanted, as ehci-hcd was loaded 
even though it was blacklisted. Rather than solve that problem, I generated a 
kernel from just before commit adfa79d with ohci-hcd built in and ehci-hcd as a 
module. This one generated the errors, but they stopped when ehci-hcd loaded. I 
also tested a 3.8-rc1 kernel with ehci-hcd and ehcd-pci built in and ohci-hcd as 
a module. No errors for that one. Your hypothesis looks correct.

I hope there is some way to force ehci-pci to load as soon as ehci-hcd is 
loaded, and before ohci-hcd loads, but if there is not, I know how to prevent 
the errors on my system even though this solution won't help the users of distro 
kernels. At least this time the errors stop once all 3 modules are loaded, and 
the number of error outputs is limited.

Thanks,

Larry

