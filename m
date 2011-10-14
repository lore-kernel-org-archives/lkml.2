Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab1JNPoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:44:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54337 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1JNPoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:44:18 -0400
Message-ID: <4E9858CB.7080005@linux.vnet.ibm.com>
Date: Fri, 14 Oct 2011 10:44:11 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] PCI: Rework config space locking, add INTx masking
 services
References: <cover.1315846441.git.jan.kiszka@siemens.com> <20111006084853.033d8d0f@jbarnes-desktop>
In-Reply-To: <20111006084853.033d8d0f@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 10:48 AM, Jesse Barnes wrote:
> On Mon, 12 Sep 2011 18:54:01 +0200
> Jan Kiszka <jan.kiszka@siemens.com> wrote:
> 
>> This series tries to heal the currently broken locking scheme around PCI
>> config space accesses.
>>
>> We have an interface lock out access via sysfs, but that service wrongly
>> assumes it is only called by one instance at a time for some device. So
>> two loops doing
>>
>> echo 1 > /sys/bus/pci/devices/<some-device>/reset
>>
>> in parallel will trigger a kernel BUG at the moment.
>>
>> Besides synchronizing with user space, we also need to manage config
>> space access of generic PCI drivers. They need to mask legacy interrupt
>> lines while the specific driver runs in user space or a guest OS.
>>
>> The approach taken here is provide mutex-like locking for general
>> access - which still requires a special mechanism due to requirements of
>> the IBM Power RAID SCSI driver. Furthermore, INTx masking is now
>> available via the PCI core and synchronized via the internal pci_lock.
>>
>> Not sure who may want to take this, so I'm CC'ing broadly.
> 
> ISTR a bunch of discussion about this (just back from lots of work
> travel and vacation, sorry I missed most of it).
> 
> Is this the agreed upon way of handling it?  If so, can I get some
> Reviewed/Acked-bys from people?

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


