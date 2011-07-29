Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1G2Li0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:38:26 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:40249 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755908Ab1G2LiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:38:25 -0400
Message-ID: <4E329B98.8070502@st.com>
Date: Fri, 29 Jul 2011 17:08:00 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>
Subject: Re: [PATCH 18/18] dmaengine/amba-pl08x: Call pl08x_free_txd()	instead
 of calling kfree() directly
References: <cover.1311936523.git.viresh.kumar@st.com> <90793b4b9824f8152aa4cea07fd91a8ecd3481e8.1311936524.git.viresh.kumar@st.com> <20110729111538.GJ25640@n2100.arm.linux.org.uk>
In-Reply-To: <20110729111538.GJ25640@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:45 PM, Russell King - ARM Linux wrote:
>> > @@ -1193,7 +1193,7 @@ static int pl08x_prep_channel_resources(struct pl08x_dma_chan *plchan,
>> >  
>> >  	num_llis = pl08x_fill_llis_for_desc(pl08x, txd);
>> >  	if (!num_llis) {
>> > -		kfree(txd);
>> > +		pl08x_free_txd(pl08x, txd);
> pl08x_free_txd() is supposed to be called under the channel spinlock,
> which is why it isn't used here.  We don't want to hold the spinlock
> throughout the LLI filling because that could cause some problems,
> and potentially worsen IRQ latency.
> 
> It's something which needs more work...

Maybe we can place lock-unlock around this call to pl08x_free_txd()?

-- 
viresh
