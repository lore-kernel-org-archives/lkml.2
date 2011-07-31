Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1GaFjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:39:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59590 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1GaFjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2MqGpbVSkuuPCZoqXw+8-RVDFFf7ju4pGaGZ9vLOXRLVhQ@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<90793b4b9824f8152aa4cea07fd91a8ecd3481e8.1311936524.git.viresh.kumar@st.com>
	<CAKnu2MqGpbVSkuuPCZoqXw+8-RVDFFf7ju4pGaGZ9vLOXRLVhQ@mail.gmail.com>
Date: Sat, 30 Jul 2011 22:39:03 -0700
Message-ID: <CAOh2x=ng=wceMtLw21jw1QF_h_zeafNCdp3EYMVxm_nvchL_yg@mail.gmail.com>
Subject: Re: [PATCH 18/18] dmaengine/amba-pl08x: Call pl08x_free_txd() instead
 of calling kfree() directly
From: viresh kumar <viresh.linux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/11, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/7/29 Viresh Kumar <viresh.kumar@st.com>:
>
>> pl08x_prep_channel_resources() is calling kfree() directly for txd(). To
>> maintain consistency in code call pl08x_free_txd() instead.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>
> Good idea,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yet there is a problem with this patch, as pointed by Russell.
pl08x_free_txd() must be called with channel lock taken. Will
check what can be done here.

--
viresh
