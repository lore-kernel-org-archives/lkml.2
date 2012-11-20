Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2KTCkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:40:55 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51546 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2KTCkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:40:53 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qAK2eF0P005910, This message is released by code: ctaloc0852
Message-ID: <50AAED8E.4030201@realsil.com.cn>
Date: Tue, 20 Nov 2012 10:40:14 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 1/2] mmc/host/rtsx: Configure SD_CFG2 register in sd_rw_multi
References: <cover.1353377266.git.wei_wang@realsil.com.cn> <00fb063304a0720f3ba9db6f79bb67263d450356.1353377266.git.wei_wang@realsil.com.cn> <87ip91f1zo.fsf@octavius.laptop.org>
In-Reply-To: <87ip91f1zo.fsf@octavius.laptop.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月20日 10:21, Chris Ball 写道:
> Hi,
>
> Sorry to be pedantic, but:
>
> On Mon, Nov 19 2012, wei_wang@realsil.com.cn wrote:
>> For Realtek card reader, internal regsiter SD_CFG2 should be configured
>> before transferring data. In the prior version, the value of this register
>> has been calculated, but forgotten to write back to the internal register.
> With what consequences?  Was the  data transfer failing?  Under which
> circumstances?
>
> Thanks,
>
> - Chris.

Hi Chris:

It's about compatibility issue. The default value of SD_CFG2 is proper 
for writing data. But for reading sequence, the timing is not good 
enough. So in some extreme circumstance,  card reader may sample the 
response data from the card as good even if the data is wrong. And this 
will cause the bad consequence.

Shall I modify the commit and resend the patchset again?

BR,
Wei WANG
