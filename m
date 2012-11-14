Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2KNDhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:37:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37795 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab2KNDhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:37:32 -0500
Message-ID: <50A311E9.9030702@gmail.com>
Date: Wed, 14 Nov 2012 11:37:13 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: Joe Jin <joe.jin@oracle.com>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <509B5038.8090304@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月09日 04:35, Dave, Tushar N 写道:
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>> On Behalf Of Joe Jin
>> Sent: Wednesday, November 07, 2012 10:25 PM
>> To: e1000-devel@lists.sf.net
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Mary Mcgrath
>> Subject: 82571EB: Detected Hardware Unit Hang
>>
>> Hi list,
>>
>> IHAC reported "82571EB Detected Hardware Unit Hang" on HP ProLiant DL360
>> G6, and have to reboot the server to recover:
>>
>> e1000e 0000:06:00.1: eth3: Detected Hardware Unit Hang:
>>   TDH                  <1a>
>>   TDT                  <1a>
>>   next_to_use          <1a>
>>   next_to_clean        <18>
>> buffer_info[next_to_clean]:
>>   time_stamp           <10047a74e>
>>   next_to_watch        <18>
>>   jiffies              <10047a88c>
>>   next_to_watch.status <1>
>> MAC Status             <80383>
>> PHY Status             <792d>
>> PHY 1000BASE-T Status  <3800>
>> PHY Extended Status    <3000>
>> PCI Status             <10>
>>
>> With newer kernel 2.0.0.1 the issue still reproducible.
>>
>> Device info:
>> 06:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet
>> Controller (Copper) (rev 06)
>> 06:00.1 0200: 8086:10bc (rev 06)
>>
>> I compared lspci output before and after the issue, different as below:
>> 06:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet
>> Controller (Copper) (rev 06)
>> 	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port
>> Gigabit Server Adapter
>> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
>> Stepping- SERR- FastB2B- DisINTx-
>> -	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>> +	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> +<TAbort- <MAbort- >SERR- <PERR- INTx+
>
> Are you sure this is not similar issue as before that you reported.
> i.e.
> On Mon, 2012-07-09 at 16:51 +0800, Joe Jin wrote:
>> I'm seeing a Unit Hang even with the latest e1000e driver 2.0.0 when
>> doing scp test. this issue is easy do reproduced on SUN FIRE X2270 M2,
>> just copy a big file (>500M) from another server will hit it at once.
>
> All devices in path from root complex to 82571, should have *same* max payload size otherwise it can cause hang.
> Can you double check this?
>

We also found such hang problem on 82599EB (ixgbe driver) in RHEL6.3
kernel, we ever tried to upgrade to latest version (3.8.21 or 3.10.17),
but it still happens.

Is it probably also due to wrong "max payload size" set in BIOS?

Thanks

Yu

> -Tushar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

