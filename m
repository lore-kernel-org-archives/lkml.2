Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2AQIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:52:17 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53936 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab2AQIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <4F140DB7.3060300@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
	<5e5d0fcff79b9b78e64c7424317d6b77736eca43.1326707233.git.viresh.kumar@st.com>
	<20120116105448.GT1068@n2100.arm.linux.org.uk>
	<4F140DB7.3060300@st.com>
Date: Tue, 17 Jan 2012 09:52:15 +0100
Message-ID: <CACRpkdY-4wWeD=3mJiChi6+4=iBMcd3kVh3h4JmDZ5ySXY3KCA@mail.gmail.com>
Subject: Re: [PATCH 7/8] dmaengine/dw_dmac: Unmap all memory buffers after
 completion of slave transfers
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Bhavna YADAV <bhavna.yadav@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:44 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 1/16/2012 4:24 PM, Russell King - ARM Linux wrote:
>> Note that DMA engine drivers are not responsible for unmapping the buffers
>> when the transfer completes - that is the responsibility of the caller.
>>
>> The automatic buffer unmapping is required for the async_tx APIs and
>> offload APIs.
>
> In dw_dmac, it is only done for slave transfers. Is this Okay ??

Basically the driver using the dmaengine shall map/unmap buffers
used for slave transfers, not the driver.

I usually map them before setting up a transfer and unmaps them
when egtting the callback from the DMA engine that the transfer is
complete.

Why do you want to do this?

Yours,
Linus Walleij
