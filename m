Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1CQTNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1CQTNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:13:02 -0400
Message-ID: <4D825D32.1080309@redhat.com>
Date: Thu, 17 Mar 2011 15:12:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, dzickus@redhat.com, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com> <20110317190932.074949b4@lxorguk.ukuu.org.uk>
In-Reply-To: <20110317190932.074949b4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/17/2011 03:09 PM, Alan Cox wrote:
>> +static struct class smbios_class = {
>> +	.name = "smbios",
>> +	.dev_release = (void(*)(struct device *)) kfree,
>> +};
>>     
> I thought the policy was no new classes- Greg ?
>   

Greg, eventually the SMBIOS code could replace the mixed DMI/SMBIOS code
we have right now.  If there is a "no new classes" policy, could you
give me an idea of what I should do/use instead?  The DMI stuff is
currently in its own class ...

>   
>> +		smbios_iounmap(buf, sizeof(*smbios_step));
>> +		printk(KERN_INFO "SMBIOS: Invalid STEP table checksum = %u\n",
>> +		       chksum1);
>>     
> Surely this isn't INFO ?
>
>   

Good point :)  I can certainly make that higher or a WARN_ON in the next
version.

P.
