Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab2CBRID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:08:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:22641 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab2CBRIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:08:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113890795"
Message-ID: <4F50FE1B.7090008@intel.com>
Date: Fri, 02 Mar 2012 17:06:35 +0000
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        "Struk, Tadeusz" <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2] Dynamically add and remove device specific reset functions
References: <4f50b540.6AzyOmpHR+z7jLk1%tadeusz.struk@intel.com> <CAErSpo6JaNXvJf_KEkRUYLed8ET4vSunfCAq9BWq3yd3+dZQpA@mail.gmail.com>
In-Reply-To: <CAErSpo6JaNXvJf_KEkRUYLed8ET4vSunfCAq9BWq3yd3+dZQpA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/12 16:29, Bjorn Helgaas wrote:
> Where do you plan to add calls to pci_dev_specific_reset_add()?  In
> drivers?

Yes, I'm working on a driver for a device with SRIOV capability.
I'll call it from there.

> Did you consider adding a "reset" function pointer to struct
> pci_driver?  That might be more natural -- the reset function is right
> with all the other code that knows about the device, and there's no
> issue with looking up the correct reset function.
> With this patch, we sort of have two different ways to map
> vendor/device IDs to code: the usual pci_register_driver() approach,
> and this one using reset_list.  If pci_driver had a "reset" pointer,
> that would be used most of the time.  You might still need the
> reset_list for generic things, e.g., the reset_intel_generic_dev()
> function, but it would be a fallback.  It might look something like:
> 
>     struct pci_driver *drv = dev->driver;
> 
>     if (drv && drv->reset) {
>         drv->reset(dev);
>         return;
>     }
> 
>     list_for_each_entry(i, &reset_list, list) {
>         ...
> 

No, I didn't think about it.
This is good idea, but for me the pci_dev_specific_reset() works fine.

> In that case, you might not even need the ability to dynamically add
> things to the list, since the only things to add would be "generic"
> things that would be more static.
> 
> Perhaps this approach was previously discussed and discarded; if so, I
> missed it.
> 
> Bjorn

Do you want me to send another patch that fixes these minor issues you pointed out?
Thanks for you comments.
Tadeusz

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


