Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab0FPG54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:57:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab0FPG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AIMDuZHxoI2F5aAb4xkrboOWUpV7al2Ka/27d04b0T5j3NxBkfb8fHb11lAve+arxq
         t/xgdqr5eNWEGi0/XOky0UsPhWFj8qrDWCsnpTMHvcpkBj3NegcVk+htOJ9VruLeZfMz
         icMT5CdqyOLZnNmXT7eB+ktMxQfRambnyjkX8=
Message-ID: <4C187603.10203@gmail.com>
Date: Tue, 15 Jun 2010 23:58:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Junchang Wang <junchangwang@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> <1276666434-11227-4-git-send-email-justinmattock@gmail.com> <20100616060738.GA12461@host-a-229.ustcsz.edu.cn>
In-Reply-To: <20100616060738.GA12461@host-a-229.ustcsz.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 11:07 PM, Junchang Wang wrote:
> On Tue, Jun 15, 2010 at 10:33:52PM -0700, Justin P. Mattock wrote:
>> @@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>> void pci_enable_bridges(struct pci_bus *bus)
>> {
>> 	struct pci_dev *dev;
>> -	int retval;
>>
>> 	list_for_each_entry(dev,&bus->devices, bus_list) {
>> 		if (dev->subordinate) {
>> 			if (!pci_is_enabled(dev)) {
>> -				retval = pci_enable_device(dev);
> Hi Justin,
>
> pci_enable_device initializes device before it's used by a driver.
>
> I think you should add check instead of eliminating pci_enable_device.
>
> For example,
> retval = pci_enable_device(dev);
> if (retval<  0) {
> 	goto handle_err;
> }
>
> --Junchang
>
>


cool, thanks for the example and info on this. I'll play around with 
this to see if I come up with anything.

cheers,

Justin P. Mattock
