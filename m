Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1GHFQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:16:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:54345 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab1GHFQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:16:31 -0400
Subject: Re: [PATCH v4 1/3] driver core: Add ability for arch code to setup pdev_archdata
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110708042235.GA26357@kroah.com>
Date: Fri, 8 Jul 2011 00:16:20 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A300A787-C750-44BF-B2EB-E09A3534058B@kernel.crashing.org>
References: <1310097643-8414-1-git-send-email-galak@kernel.crashing.org> <20110708042235.GA26357@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 7, 2011, at 11:22 PM, Greg KH wrote:

> On Thu, Jul 07, 2011 at 11:00:41PM -0500, Kumar Gala wrote:
>> On some architectures we need to setup pdev_archdata before we add the
>> device.  Waiting til a bus_notifier is too late since we might need the
>> pdev_archdata in the bus notifier.  One example is setting up of dma_mask
>> pointers such that it can be used in a bus_notifier.
>> 
>> We add weak noop version of arch_setup_pdev_archdata() and allow the arch
>> code to override with access the full definitions of struct device,
>> struct platform_device, and struct pdev_archdata.
>> 
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>> v4:
>> * Move to use a weak function based on comments from Greg
>> v3:
>> * Add more comments and add missing call to arch_setup_pdev_archdata in
>>  platform_device_register
>> v2:
>> * Added license, and comments about arch_setup_pdev_archdata()
>>  per Mike's comments
>> 
>> drivers/base/platform.c         |   22 ++++++++++++++++++++++
>> include/linux/platform_device.h |    1 +
>> 2 files changed, 23 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index 1c291af..060686d 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -32,6 +32,26 @@ struct device platform_bus = {
>> EXPORT_SYMBOL_GPL(platform_bus);
>> 
>> /**
>> + * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
>> + * @dev: platform device
>> + *
>> + * This is called before platform_device_add() such that any pdev_archdata may
>> + * be setup before the platform_notifier is called.  So if a user needs to
>> + * manipulate any relevant information in the pdev_archdata they can do:
>> + *
>> + * 	platform_devic_alloc()
>> + * 	... manipulate ...
>> + * 	platform_device_add()
>> + *
>> + * And if they don't care they can just call platform_device_register() and
>> + * everything will just work out.
>> + */
>> +void __weak arch_setup_pdev_archdata(struct platform_device *pdev)
>> +{
>> +	return ;
>> +}
> 
> The "return" isn't needed, nor is the extra ' ' there, right?  :)

yep, removed the ';' as well ;)

> Change that and you can take this through the ppc tree and add a:
> 	Acked-by: Greg Kroah-Hartman
> to them.

Ack added to all.

thanks

- k