Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2LNOWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:22:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab2LNOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:22:21 -0500
Message-ID: <50CB3662.5080100@redhat.com>
Date: Fri, 14 Dec 2012 09:23:30 -0500
From: Tony Camuso <tcamuso@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: minyard@acm.org
CC: Corey Minyard <tcminyard@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        openipmi-developer@lists.sourceforge.net, grant.likely@secretlab.ca,
        Robert Evans <Robert.Evans@stratus.com>,
        Jim Paradis <jparadis@redhat.com>
Subject: Re: [PATCH] ipmi: add new kernel options to prevent automatic ipmi
 init
References: <1355424008-20491-1-git-send-email-tcamuso@redhat.com> <50CA31BB.2030507@acm.org>
In-Reply-To: <50CA31BB.2030507@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RHEL builds the ipmi_si into the kernel by default, rather than as a
module, because it is required early in order to be available for ACPI
opregion access. However, it appears that some of our customers have
custom ipmi drivers, and this gets in their way.

Stratus is currently evaluating your suggestions, and we are expecting a
response from them sometime today or early next week.

On 12/13/2012 02:51 PM, Corey Minyard wrote:
> Well, the built-in driver works on systems that have more than one interface
> and more than one BMC, and multiple IPMBs (and all of the other channel
> types for that matter, and the driver handles all the multiplexing and nasty
> addressing).  There is, in fact, no arbitrary limit, and IBM tested
> this fairly extensively with some of their systems.  I'm not sure why you
> would need a custom driver, and if there are some custom things that need
> to be done for your servers, I'd be happy to add that.  I've worked with a
> number of other vendors to get changes like this in.  And then ipmitool,
> freeipmi, openipmi, etc. will work with the device.
>
> I don't have a big problem with this patch.  I wonder why you would want
> to compile the standard driver into your kernel if you expected to load a
> module with a custom driver later, though.  None of the distros I know of
> compile it in, it's always a module.
>
> You can also dynamically remove the device from the driver using the hot
> add/remove capability.  To remove it, you can do:
>    echo remove,`cat /proc/ipmi/0/params`
> and it will disassociate that device (IPMI interface 0 in this case) from the
> driver.  So you can iterate through all the devices in /proc/ipmi and
> remove them all at startup.
>
> If none of the above options work for you, we can go ahead with this
> patch.  Just wanted to let you know that current options exist, and see
> if you wanted to take a different direction.
>
> -corey
>
