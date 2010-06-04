Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0FDWhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:37:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60229 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab0FDWhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:37:23 -0400
Message-ID: <4C097F93.8070109@oracle.com>
Date: Fri, 04 Jun 2010 15:34:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: John Villalovos <jvillalo@redhat.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Documentation: Add doc about aerdriver.* parameters to
 kernel-parameters.txt
References: <20100602152721.GA8939@linuxjohn.usersys.redhat.com> <20100604152722.2da5de06.akpm@linux-foundation.org>
In-Reply-To: <20100604152722.2da5de06.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4C097FE7.0065:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 2 Jun 2010 11:27:22 -0400
> John Villalovos <jvillalo@redhat.com> wrote:
> 
>> Adding documentation about two aerdriver.* command line parameters.
>>
>> Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 1808f11..57ff168 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -293,6 +293,19 @@ and is between 256 and 4096 characters. It is defined in the file
>>  			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
>>  			See also header of sound/oss/aedsp16.c.
>>  
>> +	aerdriver.forceload= [HW,PCIE] Advanced Error Recovery (AER) Root Driver
>> +			{ y, n }
>> +			y: Force the AER Root driver to load
>> +			n: Do not force the AER Root driver to load [DEFAULT]
>> +			See also Documentation/PCI/pcieaer-howto.txt
>> +
>> +	aerdriver.nosourceid= [HW,PCIE]
>> +			{ y, n }
>> +			y: Use when broken hardware (mostly chipsets) has root
>> +			   ports that cannot obtain the reporting source ID.
>> +			n: [DEFAULT]
>> +			See also Documentation/PCI/pcieaer-howto.txt
>> +
>>  	agp=		[AGP]
>>  			{ off | try_unsupported }
>>  			off: disable AGP support
> 
> We don't normally document the parameters for random drivers within
> kernel-parameters.txt - that file is more for core-kernel things.
> 
> The way to document these guys is with MODULE_PARM_DESC() in
> drivers/pci/pcie/aer/aerdrv_core.c.  Coz some dope forgot to do that.
> 
> I'm sure there's some way of extracting all these random
> MODULE_PARM_DESC()s from vmlinux/modules/etc for human consumption, but
> I'm not sure what that way is.

modinfo <module.ko> does it for one binary module file.

I wrote a script a few years ago that runs 'modinfo *.ko' for all .ko files
that are found in a tree or scans all source files for MODULE_PARM_DESC().
I haven't tested it lately and I don't know of anything "official."

==> http://www.xenotime.net/linux/scripts/module-params

~Randy

