Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1I2EX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:23:27 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:43860 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab1I2EXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:23:25 -0400
Message-ID: <4E83F2A0.3090501@st.com>
Date: Thu, 29 Sep 2011 09:52:56 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] dmaengine/amba-pl08x: Add support for s3c64xx
 DMAC
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com> <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com> <4E82D0A1.8050203@st.com> <CAGOxZ53qZy+VUM65oK68W088QR=RgQ=cNxOCbO7_WESJesJaVQ@mail.gmail.com> <4E82EEE1.3020706@st.com> <CAGOxZ535KHUp6An2br0scU9HvCmg4OsnfCj7hWYq4iy+OEpO2Q@mail.gmail.com>
In-Reply-To: <CAGOxZ535KHUp6An2br0scU9HvCmg4OsnfCj7hWYq4iy+OEpO2Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 5:24 PM, Alim Akhtar wrote:
> I did Modified pl08x_cctl_bits(), but for some reason i reverted it back.
> what i was doing something like returning just __retbits__ instead of
> retbits |= tsize << PL080_CONTROL_TRANSFER_SIZE_SHIFT;
> and doing the below for the __non-s3c__ controllers in the
> pl08x_fill_lli_for_desc().
> cctl |= 1 << PL080_CONTROL_TRANSFER_SIZE_SHIFT;
> pl08x_fill_lli_for_desc(&bd, num_llis++, 1, cctl);
> 

One way out would be:
Don't do retbits |= tsize << PL080_CONTROL_TRANSFER_SIZE_SHIFT in
pl08x_cctl_bits() and do this conditionally in pl08x_fill_lli_for_desc().
This needs adding tsize argument in fill_lli_**() routine and removing it
from cctl_bits().

Probably this is what you were mentioning.

-- 
viresh
