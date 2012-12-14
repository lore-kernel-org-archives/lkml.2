Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2LNVzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:55:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab2LNVzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:55:16 -0500
Message-ID: <50CBA03D.8050409@redhat.com>
Date: Fri, 14 Dec 2012 16:55:09 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Jason Gao <pkill.2012@gmail.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com> <1355415792.2229.7.camel@ul30vt.home> <CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
In-Reply-To: <CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 09:01 PM, Jason Gao wrote:
> On Fri, Dec 14, 2012 at 12:23 AM, Alex Williamson
> <alex.williamson@redhat.com>  wrote:
>>
>> Device 03:00.0 is your raid controller:
>>
>> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
>>
>> For some reason it's trying to read from ffe65000, ffe8a000, ffe89000,
>> ffe86000, ffe87000, ffe84000.  Those are in reserved memory regions, so
>> it's not reading an OS allocated buffer, which probably means it's some
>> kind of side-band communication with a management controller.  I'd guess
>> it's a BIOS bug and there should be an RMRR covering those accesses.
>> Thanks,
>
> First of all ,I want to known whether I can ignore these errors on the
> production server,and do these error may affect the system?
>
> By the way,when I removed the "intel_iommu=on" from /etc/grub.conf,no
> DMAR related errors occur
>
> It's a strange thing,other three Dell R710 servers with the same bios
> version v. 6.3.0, same kernel 2.6.32-279.14.1 on RHEL6u3(Centos 6u3)
> ,but these errors don't appear on these tree servers
>
forgot: did you check that all the bios settings are the same btwn
         the 710 systems?

> Anyone have any idea for this ?
>
> thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

