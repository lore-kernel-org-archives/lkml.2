Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1IHDvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:51:23 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:43180 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932163Ab1IHDvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:51:21 -0400
Message-ID: <4E683B74.5000701@st.com>
Date: Thu, 8 Sep 2011 09:20:12 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len greater
 than one for slave transfers
References: <cover.1311936523.git.viresh.kumar@st.com> <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com> <20110814083618.GE4986@n2100.arm.linux.org.uk>	<4E4CCF7B.8060704@st.com> <20110821083306.GA12028@n2100.arm.linux.org.uk>	<4E532B19.6000103@st.com> <4E5715CE.2070806@st.com> <CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com> <4E575E75.40603@st.com>	<4E5F594D.10203@st.com> <438BB0150E931F4B9CE701519A4463010871804A4C@bgsmsx502.gar.corp.intel.com> <CAKnu2Mp3Ui7jZS2kjJykjuzcTzJhiAkoaVxZ2+tQX0banGh6mw@mail.gmail.com>
In-Reply-To: <CAKnu2Mp3Ui7jZS2kjJykjuzcTzJhiAkoaVxZ2+tQX0banGh6mw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2011 4:31 AM, Linus Walleij wrote:
> I think the patch brings valuable functionality we don't want to loose when
> there is a solution. Basically the dmaengine has a contract to handle
> sglists of any lengths and it's a pity that we don't, and I suspect Viresh
> cannot use the driver for MMC unless something like this is added, so
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 

Thanks Again.

> BUT I think it is possible to rewrite it a bit later so as to get a better
> handling of this. Isn't Russells initial remark that the LLI:s can simply just
> take in the entire sglist at once true?

If i am getting this clearly, the concern is "why to queue separate transfers for
individual sg's? Better would be to prepare the complete list at once and
start the transfer, so that DMA stops only after finishing all sg's
passed from user." Is this what you are pointing at?

If yes, then the same is done in this patch too. An array for llis is allocated at 
the start, then for each sg i prepare lli list from this array. Last lli from one sg
is followed by first lli from next sg. And so i get a continuous chain of llis.

-- 
viresh
