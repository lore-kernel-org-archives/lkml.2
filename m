Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1G2PWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:22:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40675 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1G2PWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110729124346.GL25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<20110729105759.GE25640@n2100.arm.linux.org.uk>
	<4E329616.2030505@st.com>
	<20110729111920.GK25640@n2100.arm.linux.org.uk>
	<4E329848.7070606@st.com>
	<20110729124346.GL25640@n2100.arm.linux.org.uk>
Date: Fri, 29 Jul 2011 08:22:40 -0700
Message-ID: <CAOh2x==-LY1qLnT=gunwbrfVe8zu0rVjHm6mGTXsE+CwE+4+_Q@mail.gmail.com>
Subject: Re: [PATCH 00/18] dmaengine/amba-pl08x updates
From: viresh kumar <viresh.linux@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: viresh kumar <viresh.kumar@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
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
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/11, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Fri, Jul 29, 2011 at 04:53:52PM +0530, viresh kumar wrote:
>> On 07/29/2011 04:49 PM, Russell King - ARM Linux wrote:
>> In my case, JPEG driver doesn't know how much data to transfer. So i have
>> to
>> send zero from there. Also, i am not sure why would peripheral needs to be
>> flow controller if the peripherals driver already know how much to
>> transfer?
>
> If the jpeg driver doesn't know how much data will be transferred, how
> can it allocate a buffer for the device to DMA into?
>

We can specify the upper limit to jpeg after which it stops the
conversion and DMA transfer
inbetween. At this time, we need to start a new DMA transfer with a
separate buffer.

Obviously, for all packets leaving the last, this upper limit is the
size of data transferred before
stopping DMA. But for the last packet we don't how much data will be
there (<= upper limit)
