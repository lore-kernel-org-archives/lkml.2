Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0DNOqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:46:23 -0400
Received: from mail.mellanox.co.il ([194.90.237.43]:56166 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755818Ab0DNOqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:46:21 -0400
Message-ID: <4BC5D529.1060701@mellanox.co.il>
Date: Wed, 14 Apr 2010 17:46:01 +0300
From: Amir Vadai <amirv@mellanox.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre)
	Gecko/20100217 Lightning/1.0b1 Shredder/3.0.3pre
MIME-Version: 1.0
To: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>
CC: "Tung, Chien Tin" <chien.tin.tung@intel.com>,
       Steve Wise <swise@opengridcomputing.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: Re: Socket Direct Protocol: help (2)
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
	<4BC49E2B.3000804@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
	<4BC4D22A.6020700@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
	<7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<4BC5D1D3.3020004@mellanox.co.il>
In-Reply-To: <4BC5D1D3.3020004@mellanox.co.il>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Apr 2010 14:46:16.0226 (UTC)
	FILETIME=[3C7A6820:01CADBE1]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17318.007
X-TM-AS-Result: No--19.717400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more thing - Please open a bug regarding the num_sge limitation at:
https://bugs.openfabrics.org/

Thanks,
Amir

On 04/14/2010 05:31 PM, Amir Vadai wrote:
> Hi,
>
> FMR are being used only in a special mode called ZCopy.
>
> You could disable this mode by setting the module paramter
> sdp_zcopy_thresh to 0, or by issuing:
> # echo 0 > /sys/module/ib_sdp/parameters/sdp_zcopy_thresh
>
> This means that you won't get the benefits of Zero-copy.
>
> - Amir
>
> On 04/14/2010 11:51 AM, Andrea Gozzelino wrote:
>   
>> On Apr 13, 2010 10:22 PM, "Tung, Chien Tin" <chien.tin.tung@intel.com>
>> wrote:
>>
>>   
>>     
>>>>>> Chien, does the NE020 support FMRs? I looked at the nes ofed-1.5
>>>>>> code
>>>>>> and it appears to do nothing in the map_phys_fmr functions.
>>>>>>
>>>>>>           
>>>>>>             
>>>>> We never implemented map_phys_fmr. Is it relevant to the # of SGEs?
>>>>>
>>>>>         
>>>>>           
>>>> No, but SDP uses FMRs. I don't think it will run without FMR support.
>>>>
>>>>       
>>>>         
>>> Good to know.  Thanks.
>>>
>>> Chien
>>>
>>>
>>>     
>>>       
>> Hi Steve and Chien,
>>
>> I understand that NE020 cards have problem with SDP connected with
>> map_phy_fmr (FMR stands for Fast Memory Region).
>> Is it possible to solve/fix this point?
>> If yes, have you an idea about the time that is necessary to code
>> development/build?
>> If no, can you suggest me a card that supports SDP protocol?
>>
>> I work on NE020 cards from February 2010 for an INFN experimental
>> proposal, called REDIGO (Read out at 10 Gbits/s), about the data
>> acquisition and movement systems. The covergence of storage protocols
>> around 10 Gigabits/s Ethernet protocols shows that one way could be the
>> Remote Direct Memory Access (RDMA). The goals are the investigations of
>> latency time, the throughput, the buffer size schemes and finally the
>> global event building bandwidth.
>>
>> Do you know if NE020 cards have problems with librdma (RDMA procedures,
>> in general) and / or with MPI versions?
>>
>> Thank you very much,
>> Andrea
>>
>> Andrea Gozzelino
>>
>> INFN - Laboratori Nazionali di Legnaro	(LNL)
>> Viale dell'Universita' 2
>> I-35020 - Legnaro (PD)- ITALIA
>> Tel: +39 049 8068346
>> Fax: +39 049 641925
>> Mail: andrea.gozzelino@lnl.infn.it			
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

