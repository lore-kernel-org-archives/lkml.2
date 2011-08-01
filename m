Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HAL4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:56:32 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:39591 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790Ab1HAL42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:56:28 -0400
Message-ID: <4E36943E.5020105@st.com>
Date: Mon, 1 Aug 2011 17:25:42 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 08/20] dmaengine/amba-pl08x: support runtime PM
References: <cover.1312190881.git.viresh.kumar@st.com> <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com> <20110801102627.GF15578@n2100.arm.linux.org.uk>
In-Reply-To: <20110801102627.GF15578@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 03:56 PM, Russell King - ARM Linux wrote:
> I think a primecell's probe function should look like this:
> 
> primecell_probe()
> {
> 	ret = amba_request_regions(adev, NULL);
> 	if (ret)
> 		return ret;
> 
> 	... allocate stuff, don't access primecell though ...
> 
> 	pm_runtime_set_active(&adev->dev);
> 	pm_runtime_enable(&adev->dev);
> 
> 	... get clocks and enable them, do rest of init ...
> 
> 	pm_runtime_put_sync(&adev->dev);
> 	return 0;
> }

Ok. I didn't had much knowhow of pm_runtime* framework. I will
send V3 for this patch alone, please see if that one is fine or still
needs some updation.

Thanks for your help.

-- 
viresh
