Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2JWBbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:31:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab2JWBbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:31:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,633,1344182400"; 
   d="scan'208";a="6047263"
Message-ID: <5085F33B.501@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 09:30:35 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Do not change worker's running cpu in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com> <20121019164233.GF11958@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F19D57AA5@ORSMSX108.amr.corp.intel.com> <5084BE7C.4020303@cn.fujitsu.com> <20121022101804.GC8352@liondog.tnic>
In-Reply-To: <20121022101804.GC8352@liondog.tnic>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 09:31:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 09:31:10,
	Serialize complete at 2012/10/23 09:31:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 06:18 PM, Borislav Petkov wrote:
> On Mon, Oct 22, 2012 at 11:33:16AM +0800, Tang Chen wrote:
>> I have 2 nodes, node0 and node1. node1 could be hotpluged.
>> node0 has cpu0 ~ cpu15, node1 has cpu16 ~ cpu31.
>>
>> I online all the cpus on node1, and hot-remove node1 directly.
>
> Hold on, I need to ask here: you soft-online all cores on node1 and
> *then* you *hot* *remove* it? So with all cores online you physically
> take out the processor from the socket? Am I reading this correctly?

Hi Borislav,

No, it's not like that. I'm sorry to make you confused.

Firstly, let me do a little explanation here. :)

I was doing ACPI based hotplug. In a container device, it contains
cpus and memories and so on. I didn't physically remove cpus from
hardware. I emulated a SCI with my own test module, and the
container_notify_cb() was called, and it recursively remove all the
sub-devices.

The "remove" here doesn't mean "taking it away". And of course, when
the "remove" is done, you can physically take the whole system board
away.

Please refer to this url:
http://www.spinics.net/lists/linux-pci/msg17651.html
This is the module we are doing the SCI emulation.

In summary, the hotplug process could be like the following:

hot-add(SCI) -> online(softly) -> device working -> offline(softly) -> 
hot-remove(SCI)


Secondly, in kernel, before a container device is removed, all its
sub-devices will be offlined and removed first. So I have all the cpus
online, and hot-remove a container(which I think is a node, maybe not)
directly. This operation has no problem, I think.

Maybe I should not say container as a node. :)

And again, sorry for the confusion.

Thanks. :)


>
> Thanks.
>

