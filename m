Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab0FQROy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:14:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61052 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0FQROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=v30yXAd31lMMMgTclWS9/QznKaQ3U1skrJO4hy3KX1uz3eV4e/a/T8vWCLJjIp+SfT
         oSi2qFs7P2XOnoqD1M4yEU6aiyRKLAeez2IVoVAUZgaePQ3tRLz76U/HUTUgWx043jyl
         b8lW2YZD6vTLUDhq4UCtYsJdRJi3++39jzOLI=
Message-ID: <4C1A581E.9050701@gmail.com>
Date: Thu, 17 Jun 2010 10:15:10 -0700
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

o.k. I looked into this one, as well as the scsi, please have a look 
when you have time and let me know what you think:


---
  drivers/pci/bus.c |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 628ea20..dba4c28 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -240,6 +240,9 @@ void pci_enable_bridges(struct pci_bus *bus)
  		if (dev->subordinate) {
  			if (!pci_is_enabled(dev)) {
  				retval = pci_enable_device(dev);
+				if (retval < 0) {
+				dev_err(&dev->dev, "maybe something here explaining something...\n");
+				}
  				pci_set_master(dev);
  			}
  			pci_enable_bridges(dev->subordinate);


Justin P. Mattock
