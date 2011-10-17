Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1JQJxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:53:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42775 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1JQJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:53:16 -0400
Message-ID: <4E9BFAF2.3040703@oracle.com>
Date: Mon, 17 Oct 2011 17:52:50 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matt Carlson <mcarlson@broadcom.com>
CC: Xiao Jiang <jgq516@gmail.com>, Michael Chan <mchan@broadcom.com>,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        Gurudas Pai <gurudas.pai@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Marsden <greg.marsden@oracle.com>
Subject: Re: [PATCH] tg3: Dont dump registers if interface not ready.
References: <4E83D3B3.7090508@oracle.com> <4E841519.6040201@gmail.com> <20111005021423.GA2787@mcarlson.broadcom.com>
In-Reply-To: <20111005021423.GA2787@mcarlson.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4E9BFB09.0107,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

Sorry for late response, after apply your changes, driver did not dumped
registers info as well, but still hit tg3_stop_block timed out as below:

tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
tg3 0000:03:01.0: tg3_stop_block timed out, ofs=4800 enable_bit=2
tg3 0000:03:01.0: eth0: Link is down
tg3 0000:03:01.1: eth1: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.1: eth1: Flow control is off for TX and off for RX
tg3 0000:03:01.1: eth1: Link is down
tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
tg3 0000:03:01.0: tg3_stop_block timed out, ofs=4800 enable_bit=2
tg3 0000:03:01.0: eth0: Link is down
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
tg3 0000:03:01.1: eth1: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.1: eth1: Flow control is off for TX and off for RX
tg3 0000:03:01.1: eth1: Link is down
tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
tg3 0000:03:01.0: tg3_stop_block timed out, ofs=4800 enable_bit=2
tg3 0000:03:01.0: eth0: Link is down
tg3 0000:03:01.1: eth1: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.1: eth1: Flow control is off for TX and off for RX
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready


Any suggestion?

Thanks,
Joe

On 10/05/11 10:14, Matt Carlson wrote:
> On Wed, Sep 28, 2011 at 11:50:01PM -0700, Xiao Jiang wrote:
>> Joe Jin wrote:
>>> When bootup the server with BCM5704 Gigabit Ethernet get below warning:
>>>
>>> tg3 0000:03:01.0: eth0: DMA Status error.  Resetting chip.
>>> <Registers state of device>
>>> tg3 0000:03:01.0: eth0: 0: Host status block [00000007:00000002:(0000:0000:0000):(0000:0000)]
>>> tg3 0000:03:01.0: eth0: 0: NAPI info [00000001:00000002:(0000:0000:01ff):0000:(00c8:0000:0000:0000)]
>>> tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
>>> tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
>>> tg3 0000:03:01.0: tg3_stop_block timed out, ofs=4800 enable_bit=2
>>> tg3 0000:03:01.0: eth0: Link is down
>>> tg3 0000:03:01.0: eth0: Link is up at 1000 Mbps, full duplex
>>> tg3 0000:03:01.0: eth0: Flow control is on for TX and on for RX
>>>
>>> If device not ready, then would not dump registers info.
>>>
>>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>>> Signed-off-by: Guru Anbalagane <guru.anbalagane@oracle.com>
>>> Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
>>> Cc: Matt Carlson <mcarlson@broadcom.com>
>>> Cc: Michael Chan <mchan@broadcom.com>
>>> ---
>>>  drivers/net/tg3.c |   11 +++++++++--
>>>   
>> Maybe this one should based on net-next tree too, the tg3.c
>> is lived below ./drivers/net/ethernet/broadcom/ in that tree.
>>
>> Thanks,
>> Xiao Jiang
>>>  1 files changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
>>> index 4a1374d..d79d344 100644
>>> --- a/drivers/net/tg3.c
>>> +++ b/drivers/net/tg3.c
>>> @@ -5475,10 +5475,15 @@ static void tg3_process_error(struct tg3 *tp)
>>>  {
>>>  	u32 val;
>>>  	bool real_error = false;
>>> +	bool dump = true;
>>>  
>>>  	if (tg3_flag(tp, ERROR_PROCESSED))
>>>  		return;
>>>  
>>> +	/* If interface not ready then dont dump error */
>>> +	if (!netif_carrier_ok(tp->dev))
>>> +		dump = false;
> 
> Would you still experience the problem if you did the following instead
> of the above link check?
> 
> 		if (tg3_flag(tp, INIT_COMPLETE))
> 			dump = false;
> 
>>>  	/* Check Flow Attention register */
>>>  	val = tr32(HOSTCC_FLOW_ATTN);
>>>  	if (val & ~HOSTCC_FLOW_ATTN_MBUF_LWM) {
>>> @@ -5492,14 +5497,16 @@ static void tg3_process_error(struct tg3 *tp)
>>>  	}
>>>  
>>>  	if (tr32(RDMAC_STATUS) || tr32(WDMAC_STATUS)) {
>>> -		netdev_err(tp->dev, "DMA Status error.  Resetting chip.\n");
>>> +		if (dump)
>>> +			netdev_err(tp->dev, "DMA Status error.  Resetting chip.\n");
>>>  		real_error = true;
>>>  	}
>>>  
>>>  	if (!real_error)
>>>  		return;
>>>  
>>> -	tg3_dump_state(tp);
>>> +	if (dump)
>>> +		tg3_dump_state(tp);
>>>  
>>>  	tg3_flag_set(tp, ERROR_PROCESSED);
>>>  	schedule_work(&tp->reset_task);
>>>   
>>
>>
> 


-- 
Oracle <http://www.oracle.com>
Joe Jin | Software Development Senior Manager | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
