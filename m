Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2AQKKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:10:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50842 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2AQKKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:10:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F140D25.1000309@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
	<7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com>
	<4F140D25.1000309@st.com>
Date: Tue, 17 Jan 2012 15:40:44 +0530
Message-ID: <CAJe_ZhfYgz5LEO7VqOJ8Qo+PZWrMNNvdfvCGQWMMq-TrbmL+xw@mail.gmail.com>
Subject: Re: [PATCH 8/8] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Bhavna YADAV <bhavna.yadav@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2012 17:12, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 1/16/2012 3:20 PM, Viresh KUMAR wrote:
>> +     /*
>> +      * Fix sconfig's burst size according to dw_dmac. We need to convert
>> +      * them as: 1 -> 0, 2 -> 1, 4 -> 2, 8 -> 3, 16 -> 4.
>> +      *
>> +      * This can be done by findiding least significant bit set: n & (n - 1)
>> +      */
>> +     sconfig->src_maxburst &= sconfig->src_maxburst - 1;
>> +     sconfig->dst_maxburst &= sconfig->dst_maxburst - 1;
>
> Perhaps, this looks incorrect. It will always return 0. :(
> Can somebody suggest any inbuild function to do this, i think
>
Calculating log2(n) which isn't very tidy. For that reason usually we make do
the other way around by saving values as power of 2 and simply left shifting
1 by that value.
In case at hand since most likely only valid values are power of 2,
maybe you can do
    maxburst = ffs(maxburst) - 1

-j
