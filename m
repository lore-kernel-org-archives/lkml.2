Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab2DXEIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 00:08:04 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:50824 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab2DXEIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 00:08:02 -0400
Message-ID: <4F9626AF.9030203@st.com>
Date: Tue, 24 Apr 2012 09:36:07 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: "ciminaghi@gnudd.com" <ciminaghi@gnudd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "pgeninatti@soft-in.com" <pgeninatti@soft-in.com>,
        "acolosimo@soft-in.com" <acolosimo@soft-in.com>,
        "alarosa@openintellect.eu" <alarosa@openintellect.eu>
Subject: Re: [PATCH] dmaengine/amba-pl08x : reset phychan_hold on terminate
 all
References: <1334830824-10908-1-git-send-email-ciminaghi@gnudd.com> <1335184940.31825.115.camel@vkoul-udesk3>
In-Reply-To: <1335184940.31825.115.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2012 6:12 PM, Vinod Koul wrote:
> On Thu, 2012-04-19 at 12:20 +0200, ciminaghi@gnudd.com wrote:
>> > From: Davide Ciminaghi <ciminaghi@gnudd.com>
>> > 
>> > When a client calls pl08x_control with DMA_TERMINATE_ALL, it is correct
>> > to terminate and release the phy channel currently in use (if one is in use),
>> > but the phychan_hold counter must also be reset (otherwise it could get
>> > trapped in an unbalanced state).
>> > 
>> > Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
>> > ---
>> >  drivers/dma/amba-pl08x.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
>> > index c301a8e..3d704ab 100644
>> > --- a/drivers/dma/amba-pl08x.c
>> > +++ b/drivers/dma/amba-pl08x.c
>> > @@ -1429,6 +1429,7 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>> >  			 * signal
>> >  			 */
>> >  			release_phy_channel(plchan);
>> > +			plchan->phychan_hold = 0;
>> >  		}
>> >  		/* Dequeue jobs and free LLIs */
>> >  		if (plchan->at) {
> Linus, Viresh... Any tested-by for this before I apply to fixes.

Looks good.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
