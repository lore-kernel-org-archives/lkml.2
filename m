Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HDGbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:31:45 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:40528 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084Ab1HDGbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:31:39 -0400
Message-ID: <4E3A3CB7.8040505@st.com>
Date: Thu, 4 Aug 2011 12:01:19 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 08/20] dmaengine/amba-pl08x: support runtime PM
References: <cover.1312190881.git.viresh.kumar@st.com>	 <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com>	 <20110803123953.GB23953@n2100.arm.linux.org.uk>  <4E3A2BFC.3070907@st.com> <1312436185.1536.570.camel@vkoul-udesk3>
In-Reply-To: <1312436185.1536.570.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 11:06 AM, Koul, Vinod wrote:
> On Thu, 2011-08-04 at 10:49 +0530, viresh kumar wrote:
>> On 08/03/2011 06:09 PM, Russell King - ARM Linux wrote:
>>> On Mon, Aug 01, 2011 at 03:07:18PM +0530, Viresh Kumar wrote:
>> @@ -405,6 +406,7 @@ pl08x_get_phy_channel(struct pl08x_driver_data *pl08x,
>>  		return NULL;
>>  	}
>>  
>> +	pm_runtime_get_sync(&pl08x->adev->dev);
> this should be ideally one of the first things you would do not last.
> get_sync will ensure your .runtime_resume callback is called before it
> returns (if its suspended)
>>  	return ch;
>>  }

Until this point we are not touching the registers at all. And they will
accessed after this point only.

>> +	pm_runtime_put(&adev->dev);
> _put is probe looks suspect, why do you need this here 

To save power.

> as you are already setting the status as active, this _put will decrement your
> usage count and possibly call your runtime_suspend

We set status as active, as amba/bus layer has enabled it before calling
probe and it doesn't put it.

As DMA will not be used until get_phy_channel() is called, so we can save
some energy here too. So i put it here.

-- 
viresh
