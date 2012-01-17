Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2AQItU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:49:20 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34348 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463Ab2AQItT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:49:19 -0500
MIME-Version: 1.0
In-Reply-To: <4F140D25.1000309@st.com>
References: <cover.1326707233.git.viresh.kumar@st.com>
	<7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com>
	<4F140D25.1000309@st.com>
Date: Tue, 17 Jan 2012 09:49:18 +0100
Message-ID: <CACRpkdbY7ZOwY6GR4t+GODYL4yAdH-PXExmwp84R+Gz2W19X7w@mail.gmail.com>
Subject: Re: [PATCH 8/8] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:42 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
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
> find_next_bit(sconfig->src_maxburst, sizeof(sconfig->src_maxburst), 0)
>
> will do it.

Are you looking for ffs() from <linus/bitops.h>?

find-first-set (the include boils down to include/asm-generic/bitops/ffs.h
if you want to check the implementation).

Linus Walleij
