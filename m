Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2JRCSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:18:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21707 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2JRCSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:18:15 -0400
Message-ID: <507F66DF.4080606@oracle.com>
Date: Thu, 18 Oct 2012 10:18:07 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
CC: Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Marsden <greg.marsden@oracle.com>
Subject: Re: [PATCH] qla3xxx: Ensure req_q_phy_addr writes to the register
References: <507E50E5.5040201@oracle.com> <5E4F49720D0BAD499EE1F01232234BA87744A93B8E@AVEXMB1.qlogic.org>
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA87744A93B8E@AVEXMB1.qlogic.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/12 01:45, Jitendra Kalsaria wrote:
> 
> 
>> -----Original Message-----
>> From: Joe Jin [mailto:joe.jin@oracle.com] 
>> Sent: Tuesday, October 16, 2012 11:32 PM
>> To: Ron Mercer; Jitendra Kalsaria; Dept-Eng Linux Driver
>> Cc: netdev; linux-kernel; Greg Marsden
>> Subject: [PATCH] qla3xxx: Ensure req_q_phy_addr writes to the register
>>
>> Make sure req_q_phy_addr write to the register.
>>
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>> Cc: Ron Mercer <ron.mercer@qlogic.com>
>> Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
>> ---
>> drivers/net/ethernet/qlogic/qla3xxx.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
>> index df09b1c..78b4cba 100644
>> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
>> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
>> @@ -2525,6 +2525,12 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
>> 	qdev->req_q_size =
>> 	    (u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
>>
>> +	/*
>> +	 * The barrier is required to ensure that req_q_phy_addr writes to
>> +	 * the memory.
>> +	 */
>> +	wmb();
>> +
>> 	qdev->req_q_virt_addr =
>> 	    pci_alloc_consistent(qdev->pdev,
>> 				 (size_t) qdev->req_q_size,
> 
> Your changes only take care of request queue but not response queue which also need barrier.

Jiten,

Thanks for review!
The barrier to make sure writel() call for req_q_phy_addr and rsp_q_phy_addr in 
ql_adapter_initialize(), so I think call once wmb() is enough but I need to update
the comment, any idea?

Thanks,
Joe

> 
> 	qdev->req_q_size =
> 		(u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
> 
> 	qdev->rsp_q_size = NUM_RSP_Q_ENTRIES * sizeof(struct net_rsp_iocb);
> 
> 	wmb();
> 
> thanks,
> 	Jiten
> 


-- 
Oracle <http://www.oracle.com>
Joe Jin | Software Development Senior Manager | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
