Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2APLmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:42:52 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:59748 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173Ab2APLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:42:50 -0500
Message-ID: <4F140D25.1000309@st.com>
Date: Mon, 16 Jan 2012 17:12:29 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "vinod.koul@intel.com" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH 8/8] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
References: <cover.1326707233.git.viresh.kumar@st.com> <7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com>
In-Reply-To: <7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2012 3:20 PM, Viresh KUMAR wrote:
> +	/*
> +	 * Fix sconfig's burst size according to dw_dmac. We need to convert
> +	 * them as: 1 -> 0, 2 -> 1, 4 -> 2, 8 -> 3, 16 -> 4.
> +	 *
> +	 * This can be done by findiding least significant bit set: n & (n - 1)
> +	 */
> +	sconfig->src_maxburst &= sconfig->src_maxburst - 1;
> +	sconfig->dst_maxburst &= sconfig->dst_maxburst - 1;

Perhaps, this looks incorrect. It will always return 0. :(
Can somebody suggest any inbuild function to do this, i think

find_next_bit(sconfig->src_maxburst, sizeof(sconfig->src_maxburst), 0)

will do it.

-- 
viresh
