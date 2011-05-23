Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1EWQXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:23:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30239 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab1EWQXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:23:21 -0400
Message-ID: <4DDA89A2.8010604@oracle.com>
Date: Mon, 23 May 2011 09:21:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ata: PATA_ARASAN_CF depends on DMADEVICES
References: <20110520165507.cba539d5.sfr@canb.auug.org.au> <20110522173227.5ba18817.randy.dunlap@oracle.com> <4DD9D5EB.3060807@st.com>
In-Reply-To: <4DD9D5EB.3060807@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DDA89B0.006F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/11 20:35, viresh kumar wrote:
> On 05/23/2011 06:02 AM, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix kconfig unmet dependency warning:
>>
>> warning: (PATA_ARASAN_CF && VIDEO_TIMBERDALE && SND_SOC_SH4_SIU) selects DMA_ENGINE which has unmet direct dependencies (DMADEVICES)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Viresh Kumar <viresh.kumar@st.com>
>> ---
>>  drivers/ata/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-next-20110520.orig/drivers/ata/Kconfig
>> +++ linux-next-20110520/drivers/ata/Kconfig
>> @@ -313,6 +313,7 @@ config PATA_AMD
>>  
>>  config PATA_ARASAN_CF
>>  	tristate "ARASAN CompactFlash PATA Controller Support"
>> +	depends on DMADEVICES
>>  	select DMA_ENGINE
> 
> Randy,
> 
> I think we can also remove this "select DMA_ENGINE" line.

In that case, the newly added "depends on" line is not needed either,
since the "select DMA_ENGINE" is what causes the kconfig warning message.


> Otherwise, it looks fine.
> 
> Acked-by: Viresh Kumar <viresh.kumar@st.com>
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
