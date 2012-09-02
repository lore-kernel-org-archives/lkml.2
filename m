Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2IBUEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:04:21 -0400
Received: from antcom.de ([188.40.178.216]:47904 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab2IBUET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:04:19 -0400
Message-ID: <5043BBBE.30409@antcom.de>
Date: Sun, 02 Sep 2012 22:04:14 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: shiraz hashim <shiraz.linux.kernel@gmail.com>
CC: linus.walleij@linaro.org, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Subject: Re: [PATCH v6 1/3] spi/pl022: Add chip select handling via GPIO
References: <1345643359-16584-1-git-send-email-stigge@antcom.de> <CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
In-Reply-To: <CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shiraz,

On 01/09/12 13:14, shiraz hashim wrote:
> On Wed, Aug 22, 2012 at 7:19 PM, Roland Stigge <stigge@antcom.de> wrote:
>> @@ -2016,6 +2030,8 @@ pl022_probe(struct amba_device *adev, co
>>         pl022->master_info = platform_info;
>>         pl022->adev = adev;
>>         pl022->vendor = id->data;
>> +       /* Point chipselects to allocated memory beyond the main struct */
>> +       pl022->chipselects = (int *) pl022 + sizeof(struct pl022);
> 
> This is going beyond memory allocated for chipselects
> as it adds 4 * sizeof(struct pl022) bytes to pl022.
> 
> pl022->chipselects = (int *) &pl022[1];

Correct. Thanks for the heads up!

Funnily, my previous proposal way actually like you just proposed, but
we took the other one since it looked "better". ;-)

I'll provide an incremental bugfix patch since Mark already has the
commit in his misc.git tree.

Thanks again,

Roland
