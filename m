Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab1JYMcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:32:25 -0400
Received: from goliath.siemens.de ([192.35.17.28]:17463 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab1JYMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:32:19 -0400
Message-ID: <4EA6AC43.1010501@siemens.com>
Date: Tue, 25 Oct 2011 14:32:03 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] PCI: Rework config space locking, add INTx masking
 services
References: <cover.1315846441.git.jan.kiszka@siemens.com> <20111006084853.033d8d0f@jbarnes-desktop> <4E984BD2.6090907@siemens.com>
In-Reply-To: <4E984BD2.6090907@siemens.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-14 16:48, Jan Kiszka wrote:
> On 2011-10-06 17:48, Jesse Barnes wrote:
>> On Mon, 12 Sep 2011 18:54:01 +0200
>> Jan Kiszka <jan.kiszka@siemens.com> wrote:
>>
>>> This series tries to heal the currently broken locking scheme around PCI
>>> config space accesses.
>>>
>>> We have an interface lock out access via sysfs, but that service wrongly
>>> assumes it is only called by one instance at a time for some device. So
>>> two loops doing
>>>
>>> echo 1 > /sys/bus/pci/devices/<some-device>/reset
>>>
>>> in parallel will trigger a kernel BUG at the moment.
>>>
>>> Besides synchronizing with user space, we also need to manage config
>>> space access of generic PCI drivers. They need to mask legacy interrupt
>>> lines while the specific driver runs in user space or a guest OS.
>>>
>>> The approach taken here is provide mutex-like locking for general
>>> access - which still requires a special mechanism due to requirements of
>>> the IBM Power RAID SCSI driver. Furthermore, INTx masking is now
>>> available via the PCI core and synchronized via the internal pci_lock.
>>>
>>> Not sure who may want to take this, so I'm CC'ing broadly.
>>
>> ISTR a bunch of discussion about this (just back from lots of work
>> travel and vacation, sorry I missed most of it).
>>
>> Is this the agreed upon way of handling it?  If so, can I get some
>> Reviewed/Acked-bys from people?
> 
> I hope this is acceptable. These changes are required for further
> improvements of the KVM device assignment support (INTx sharing). So I
> would appreciate any ack or whatever feedback as well.

At least two acks arrived by now. But I guess this series is not yet
lined up for the 3.2 window, is it? Can we get it merged for 3.3? Just
let me know if any rebasing is required and against which tree.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
