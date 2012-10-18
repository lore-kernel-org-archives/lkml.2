Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2JRRKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:10:51 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:3309
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533Ab2JRRKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:10:50 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zcb8kz9371I1102I542M1432Izz1202h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1155h)
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Joe Jin <joe.jin@oracle.com>
CC: Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Marsden <greg.marsden@oracle.com>
Date: Thu, 18 Oct 2012 10:10:42 -0700
Subject: RE: [PATCH] qla3xxx: Ensure req_q_phy_addr writes to the register
Thread-Topic: [PATCH] qla3xxx: Ensure req_q_phy_addr writes to the register
Thread-Index: Ac2s1taiX9RX+kPARUCoOL0Y4nNpDgAG4/YQ
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87744A93DE8@AVEXMB1.qlogic.org>
References: <507E50E5.5040201@oracle.com>
 <5E4F49720D0BAD499EE1F01232234BA87744A93B8E@AVEXMB1.qlogic.org>
 <507F66DF.4080606@oracle.com>
In-Reply-To: <507F66DF.4080606@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9IHAuuC011914



>>> -----Original Message-----
>>> From: Joe Jin [mailto:joe.jin@oracle.com] 
>>> Sent: Tuesday, October 16, 2012 11:32 PM
>>> To: Ron Mercer; Jitendra Kalsaria; Dept-Eng Linux Driver
>>> Cc: netdev; linux-kernel; Greg Marsden
>>> Subject: [PATCH] qla3xxx: Ensure req_q_phy_addr writes to the register
>>>
>>> Make sure req_q_phy_addr write to the register.
>>>
>>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>>> Cc: Ron Mercer <ron.mercer@qlogic.com>
>>> Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
>>> ---
>>> drivers/net/ethernet/qlogic/qla3xxx.c | 6 ++++++
>>> 1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
>>> index df09b1c..78b4cba 100644
>>> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
>>> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
>>> @@ -2525,6 +2525,12 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
>>> 	qdev->req_q_size =
>>> 	    (u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
>>>
>>> +	/*
>>> +	 * The barrier is required to ensure that req_q_phy_addr writes to
>>> +	 * the memory.
>>> +	 */
>>> +	wmb();
>>> +
>>> 	qdev->req_q_virt_addr =
>>> 	    pci_alloc_consistent(qdev->pdev,
>>> 				 (size_t) qdev->req_q_size,
>> 
>> Your changes only take care of request queue but not response queue which also need barrier.
>
>Jiten,
>
>Thanks for review!
>The barrier to make sure writel() call for req_q_phy_addr and rsp_q_phy_addr in 
>ql_adapter_initialize(), so I think call once wmb() is enough but I need to update
>the comment, any idea?

Yes and something like "ensure request/response queue addr writes to the register"

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
