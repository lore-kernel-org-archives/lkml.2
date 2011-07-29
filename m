Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1G2LOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:14:50 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:38966 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886Ab1G2LOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:14:49 -0400
Message-ID: <4E329616.2030505@st.com>
Date: Fri, 29 Jul 2011 16:44:30 +0530
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
Subject: Re: [PATCH 00/18] dmaengine/amba-pl08x updates
References: <cover.1311936523.git.viresh.kumar@st.com> <20110729105759.GE25640@n2100.arm.linux.org.uk>
In-Reply-To: <20110729105759.GE25640@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Russell,

On 07/29/2011 04:27 PM, Russell King - ARM Linux wrote:
> Peripheral flow is broken beyond belief.  It doesn't work for at all
> for scatterlists.  The way peripheral flow control works on PL08x is
> as follows:
> 
> 1. You build a scatterlist which is a list of [address, length] pairs
> 2. You pass that to the DMA controller.  The DMA controller ignores the
>    length field.
> 3. The DMA controller reads/writes to [address] and increments it.
> 4. The DMA controller moves to the next SG entry when the peripheral
>    signals an end-of-transfer.
> 
> Please explain how you're getting around the issue where the scatterlist
> length is not respected by the DMA controller.

There can be two cases here:

- Memory addresses are contiguous and are not scattered.
Here, Only one sg will be passed by user driver, with memory address and
zero length. We pass this to controller and after the transfer it will
receive the last burst request from peripheral and so transfer finishes.

- Memory addresses are scattered and are not contiguous.
Here, Obviously as DMA controller doesn't know when a lli's transfer gets over,
it can't load next lli. So in this case, there has to be an assumption that only
one lli is supported. Thus, we can't have scattered addresses.

I haven't added any comment for second case anywhere in the code. Will do that
after i get first level of review comments.

-- 
viresh
