Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2AaXFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 18:05:04 -0500
Received: from mtv-iport-2.cisco.com ([173.36.130.13]:41739 "EHLO
	mtv-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2AaXFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 18:05:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsHAD9zKE+rRDoG/2dsb2JhbABCgw2rWoEFgXIBAQEEEgFlARALFAQJFg8JAwIBAgFFBg0BBQIBAR6iFAGeVIsRAQQCAQICCQICAQYHAxMBCAUDAwkfgnIZBAMMAxQFVw0BBAQMAgoCgz0EiECMYIVXjR0
X-IronPort-AV: E=Sophos;i="4.71,599,1320624000"; 
   d="scan'208";a="28055755"
Message-ID: <4F28739C.1040907@cisco.com>
Date: Tue, 31 Jan 2012 16:05:00 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: VFs go missing with latest kernel
References: <4F287102.3060600@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 03:58 PM, Rose, Gregory V wrote:
>> Note that all of the even numbered VFs have disappeared. Accordingly,
>> trying to launch the VM to which the VFs are assigned fails. git bisect
>> pointed to this commit:
>>
>> 0224d663063d542b3d829706f3fcbd0f640f19b3 is the first bad commit
>> commit 0224d663063d542b3d829706f3fcbd0f640f19b3
>> Author: Greg Rose <gregory.v.rose@intel.com>
>> Date:   Fri Oct 14 02:57:14 2011 +0000
>>
>>     igb: Check if subordinate VFs are assigned to virtual machines
>>
>>     Kvm and the Xen pci-back driver will set a flag in the virtual
>> function
>>     pci device dev_flags when the VF is assigned to a guest VM.  Before
>>     destroying subordinate VFs check to see if the flag is set and if so
>>     skip the call to pci_disable_sriov() to avoid system crashes.
>>
>>     Copy the maintainer for the Xen pci-back driver.  Also CC'ing
>>     maintainers of all drivers found to call pci_disable_sriov().
>>
>>
>> Sure enough reverting the patch on 3.3.0-rc1 makes the VFs visible again.
>>
>> I am hitting some other problem trying to use the VF on 3.3.0-rc1 -- KVM
>> fails the KVM_CAP_IOMMU check though the server has one (works fine with
>> the older kernel) and it is built into the kernel. Debugging that
>> problem now.
> 
> I'll see if I can reproduce that.  Is this all after a fresh boot with no unloading/reloading of the PF driver?

Build kernel, reboot, run lspci - note missing VFs.

