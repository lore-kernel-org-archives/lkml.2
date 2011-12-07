Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1LGUPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:15:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50043 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab1LGUPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:15:23 -0500
MIME-Version: 1.0
In-Reply-To: <4EDB9276.6070302@linux.vnet.ibm.com>
References: <CAGPN=9SQraacGpNJTtsA4NUk8Re1neJaDt42u8HFw8Hg-+n5BQ@mail.gmail.com>
	<4EDB9276.6070302@linux.vnet.ibm.com>
Date: Wed, 7 Dec 2011 21:15:22 +0100
Message-ID: <CAGPN=9TwGHgJsRYkBYzwSPn2zMRy9gvktNbkLaF_h-ocTNPK0Q@mail.gmail.com>
Subject: Re: xhci_hcd: Runtime PM causes port to inactivate
From: Patrik Kullman <patrik.kullman@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        michal@ellpspace.math.ualberta.ca, Oliver Neukum <oneukum@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, I've been digging deeper into the suspend-issue, and the
xhci_hcd module is not to blame in my case. Running 3.2-rc4+, I only
need to use the parts of the script that unbinds/binds the ehci_hcd
module.

However, the original case of setting
/sys/bus/pci/devices/0000:03:00.0/power/control to "auto" causing the
USB-port to be inactivated is still valid.

2011/12/4 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> There is a very similar discussion going on at:
> http://thread.gmane.org/gmane.linux.kernel/1222803
>
> Cc'ing all the relevant people and mailing lists.
>
> Regards,
> Srivatsa S. Bhat
>
> On 12/04/2011 04:47 PM, Patrik Kullman wrote:
>
>> Issuing
>>
>> echo auto > /sys/bus/pci/devices/0000:03:00.0/power/control
>>
>> on my Asus Zenbook UX31E with a
>>
>> 03:00.0 USB Controller: Fresco Logic Device 1009 (rev 02)
>>
>> causes its USB3-port to become mostly disabled.
>>
>> It does have a "Charger+" feature that allows it to charge cellphones
>> etc even when turned off, and this feature works when power control is
>> in "auto" mode.
>>
>> In all other aspects, the port is turned off. It doesn't react to
>> devices being inserted.
>>
>> This does not feel like the desired behavior.
>>
>> Also, suspend does not work without unbinding the xhci_hcd module, not
>> sure if that is related.
>> Computer will not suspend/resume unless the following script is used
>> in /etc/pm/sleep.d:
>> https://help.ubuntu.com/community/AsusZenbook#Suspend.2C_Hibernate.2C_Shut-down_and_Reboot
>>
>> This behavior has not changed between 3.0 and 3.2-rc4+ that I've tried today.
