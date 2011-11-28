Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1K1EFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:05:54 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:43507 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624Ab1K1EFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:05:53 -0500
Message-ID: <4ED30893.6080601@st.com>
Date: Mon, 28 Nov 2011 09:35:39 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>
Subject: Re: [PATCH 1/3] dmaengine: Allow controller drivers to set channel
 ids
References: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com> <1317200887.1573.1768.camel@vkoul-udesk3>
In-Reply-To: <1317200887.1573.1768.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 2:38 PM, Vinod Koul wrote:
> On Thu, 2011-09-22 at 16:13 +0530, Viresh Kumar wrote:
>> > Currently value of chan_id field is updated by dmaengine.c while the dma device
>> > is registered. In some cases the controller driver may need to assign channel
>> > numbers by itself. For example, dw_dmac.c wants to control the order in which
>> > channels are allocated by dmaengine. So it added channels inside channel list of
>> > dma_device in reverse order. Now channel 7 is allocated first and channel 0 is
>> > allocated last.
>> > 
>> > But as the channel ids are updated by dmaengine, channel numbers in sysfs will
>> > be overwritten if controller has added channels in reverse order. To represent
>> > correct channel number in sysfs, it is required that dmaengine must not assume
>> > that first channel in list is channel 0 and last is 7.
> to dmaengine, this is just a channel representation in sysfs and nothing
> more. If damc is assuming that this is same as what dmaengine will do
> then dmac is wrong.
> 
> Nevertheless, Dan was okay with changing this representation.
> Dan I would need your comments/Ack before we discuss this further

Dan/Vinod,

Any feedback on this patchset?

-- 
viresh
