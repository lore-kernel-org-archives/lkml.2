Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2L0XkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:40:12 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:55521 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2L0XkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:40:08 -0500
Message-ID: <50DCDC54.4020508@lwfinger.net>
Date: Thu, 27 Dec 2012 17:40:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
References: <Pine.LNX.4.44L0.1212271803570.9950-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1212271803570.9950-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 05:18 PM, Alan Stern wrote:
> On Thu, 27 Dec 2012, Larry Finger wrote:
>
>> I could not do exactly the experiment that you wanted, as ehci-hcd was loaded
>> even though it was blacklisted. Rather than solve that problem, I generated a
>> kernel from just before commit adfa79d with ohci-hcd built in and ehci-hcd as a
>> module. This one generated the errors, but they stopped when ehci-hcd loaded. I
>> also tested a 3.8-rc1 kernel with ehci-hcd and ehcd-pci built in and ohci-hcd as
>> a module. No errors for that one. Your hypothesis looks correct.
>>
>> I hope there is some way to force ehci-pci to load as soon as ehci-hcd is
>> loaded, and before ohci-hcd loads, but if there is not, I know how to prevent
>> the errors on my system even though this solution won't help the users of distro
>> kernels. At least this time the errors stop once all 3 modules are loaded, and
>> the number of error outputs is limited.
>
> This is now a userspace issue.  Perhaps a change to a udev rule will
> prevent ohci-hcd from loading until ehci-pci is in place.  Or a change
> to a startup script in your initramfs.  However the problem gets
> solved, there doesn't seem to be much the kernel can do about it.

Thanks for looking at this. At the moment, there are no udev rules on my system 
that mention "ehci" or "ohci". Perhaps a suitable one can be prepared. In 
addition, I still need to look at the startup scripts to see if there is a 
possible fix there.

Larry


