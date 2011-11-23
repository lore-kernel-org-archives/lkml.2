Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1KWLMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:12:05 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:56277 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab1KWLMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:12:00 -0500
Message-ID: <4ECCD4F4.8080903@st.com>
Date: Wed, 23 Nov 2011 16:41:48 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH] dmaengine/dw_dmac: Reconfigure interrupt and chan_cfg
 register on resume
References: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>  <1321935206.1516.217.camel@vkoul-udesk3>  <4ECB3F1F.9060806@st.com> <1322045375.1516.249.camel@vkoul-udesk3>
In-Reply-To: <1322045375.1516.249.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 4:19 PM, Vinod Koul wrote:
> then why not perform save and restore in your suspend and restore
> callbacks. That way you don't pay penalty of doing that in every alloc
> as you seem to be doing now?

Not actually. I am not saving anything to be restored after suspend.
There are few things (configuring CFG regs and enabling interrupts),
which are done earlier on alloc_channels. As this will not be called after
resume, so we need to set them again.

What i have done is, removed all this stuff from alloc channels and moved it
to dwc_dostart(). Here, i am checking if channel is already programmed or not.
If not (Can happen only in two cases: On resume and other on fresh channel alloc),
i configure them. So there is no save/restore actually done.

-- 
viresh
