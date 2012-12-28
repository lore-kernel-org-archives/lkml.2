Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab2L1GHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 01:07:21 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:39778
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab2L1GHT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 01:07:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I154dI542I1432I4015Izz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h946hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758hbe9i1155h)
From: Liu Hui-R64343 <r64343@freescale.com>
To: David Rientjes <rientjes@google.com>
CC: Mel Gorman <mgorman@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: echo 1 > /proc/sys/vm/compact_memory -> sh: write error: Bad
 address
Thread-Topic: echo 1 > /proc/sys/vm/compact_memory -> sh: write error: Bad
 address
Thread-Index: Ac3kJF/a6SI7D+iJS5WtP6F+qKZUbAAXonEAAA+XjfA=
Date: Fri, 28 Dec 2012 06:07:13 +0000
Message-ID: <AD13664F485EE54694E29A7F9D5BE1AF4D5027@039-SN2MPN1-021.039d.mgd.msft.net>
References: <AD13664F485EE54694E29A7F9D5BE1AF4D35F3@039-SN2MPN1-021.039d.mgd.msft.net>
 <alpine.DEB.2.00.1212271435250.18214@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212271435250.18214@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.64]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: David Rientjes [mailto:rientjes@google.com]
>Sent: Friday, December 28, 2012 6:39 AM
>To: Liu Hui-R64343
>Cc: Mel Gorman; linux-kernel@vger.kernel.org
>Subject: Re: echo 1 > /proc/sys/vm/compact_memory -> sh: write error: Bad
>address
>
>On Thu, 27 Dec 2012, Liu Hui-R64343 wrote:
>
>> diff --git a/mm/compaction.c b/mm/compaction.c index c4bc5ac..d3cb27f
>> 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -732,8 +732,10 @@ int sysctl_compact_memory;  int
>> sysctl_compaction_handler(struct ctl_table *table, int write,
>>                         void __user *buffer, size_t *length, loff_t
>> *ppos)  {
>> -       if (write)
>> -               return compact_nodes();
>> +       if (write) {
>> +               compact_nodes();
>> +               return *length;
>> +       }
>>
>>         return 0;
>>  }
>
>No need to return the length at all, simply change compact_nodes() to return
>void, remove the return value, and do
>
>	if (write)
>		compact_nodes();
>	return 0;
>
>and it should be fixed. 

Yes,  this works. Thanks,

> Could you write a changelog that shows the before
>and after behavior (not necessarily the implementation), sign-off the patch
>as described in Documentation/SubmittingPatches, running
>scripts/get_maintainer.pl on your new patch file, and sending it to all
>addresses that are listed?

OK, I will send out the patch as you suggested.

Happy holiday.

Jason Liu

