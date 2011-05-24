Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1EXDjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:39:24 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36625 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757Ab1EXDjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:39:23 -0400
Message-ID: <4DDB284A.6040603@st.com>
Date: Tue, 24 May 2011 09:08:50 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ata: PATA_ARASAN_CF depends on DMADEVICES
References: <20110520165507.cba539d5.sfr@canb.auug.org.au> <20110522173227.5ba18817.randy.dunlap@oracle.com> <4DD9D5EB.3060807@st.com> <4DDA89A2.8010604@oracle.com>
In-Reply-To: <4DDA89A2.8010604@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 09:51 PM, Randy Dunlap wrote:
>>> >>  config PATA_ARASAN_CF
>>> >>  	tristate "ARASAN CompactFlash PATA Controller Support"
>>> >> +	depends on DMADEVICES
>>> >>  	select DMA_ENGINE
>> > 
>> > Randy,
>> > 
>> > I think we can also remove this "select DMA_ENGINE" line.
> In that case, the newly added "depends on" line is not needed either,
> since the "select DMA_ENGINE" is what causes the kconfig warning message.
> 

Some sort of dependency must be present as PATA_ARASAN is using DMAENGINE
routines and it will not compile unless DMA_ENGINE is enabled.

So, depends on DMADEVICES will solve all these issues.

-- 
viresh
