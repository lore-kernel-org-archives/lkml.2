Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab2FHBM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:12:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60810 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529Ab2FHBMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:12:54 -0400
Message-ID: <4FD15193.8080800@gmail.com>
Date: Thu, 07 Jun 2012 20:12:51 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Doug Thompson <dougthompson@xmission.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] edac: add support for Calxeda highbank memory controller
References: <1339020125-20198-1-git-send-email-robherring2@gmail.com> <1339020125-20198-2-git-send-email-robherring2@gmail.com> <4FCFDB12.3090403@redhat.com>
In-Reply-To: <4FCFDB12.3090403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On 06/06/2012 05:34 PM, Mauro Carvalho Chehab wrote:
> Hi Rob,
> 
> Em 06-06-2012 19:02, Rob Herring escreveu:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add support for memory controller on Calxeda Highbank platforms. Highbank
>> platforms support a single 4GB mini-DIMM with 1-bit correction and 2-bit
>> detection.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   17 ++
>>  arch/arm/boot/dts/highbank.dts                     |    6 +
>>  drivers/edac/Kconfig                               |    9 +-
>>  drivers/edac/Makefile                              |    2 +
>>  drivers/edac/highbank_mc_edac.c                    |  238 ++++++++++++++++++++
>>  5 files changed, 271 insertions(+), 1 deletion(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
>>  create mode 100644 drivers/edac/highbank_mc_edac.c

[snip]

>> +
>> +static struct mcidev_sysfs_attribute highbank_mc_sysfs_attributes[] = {
>> +	{
>> +	 .attr = {
>> +		  .name = "inject_ctrl",
>> +		  .mode = (S_IRUGO | S_IWUSR)
>> +		  },
>> +	 .store = highbank_mc_inject_ctrl_store,
>> +	},
>> +	{
>> +	 .attr = {.name = NULL} /* End of list */
>> +	}
>> +};
> 
> This won't work after the kobj->struct device conversion patches that are at
> -next tree, as this struct will not exist anymore.
> 
> Also, as this is for error injection, the better is to use debugfs.
> 
> It shouldn't be hard to change it to use debugfs. If you want an example, you
> can take a look on this patch:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=303f3e2113d81d49feef9c0803c2958d41513f14
> 

I've got this working, but don't really like the resulting debugfs
layout. I end-up with something like this (using dev_name() of platform
driver):

/mc0/fake*
/fff00000.memory-controller/inject_ctrl

It would be nice if there was a top level edac directory and any entries
I add are added under mcX. I can do that for the next version if that's
okay.

Rob
