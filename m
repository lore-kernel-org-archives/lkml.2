Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031048Ab2B2OiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:38:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27752 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2B2OiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:38:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6634"; a="165188395"
X-IronPort-AV: E=Sophos;i="4.73,502,1325491200"; 
   d="scan'208";a="187740713"
Message-ID: <4F4E384D.2090802@qca.qualcomm.com>
Date: Wed, 29 Feb 2012 16:38:05 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        David Miller <davem@davemloft.net>,
        "andrei.emeltchenko.news@gmail.com" 
	<andrei.emeltchenko.news@gmail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: Add some --strict coding style checks
References: <20120221151435.GA19354@tuxdriver.com>	 <20120221.144417.1445117001833888214.davem@davemloft.net>	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>	 <20120221.154053.2103818562080068513.davem@davemloft.net>	 <1329857959.5143.11.camel@joe2Laptop>	 <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>	 <1329874581.5143.22.camel@joe2Laptop>	 <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>	 <1329875935.5143.24.camel@joe2Laptop>	 <804857E1F29AAC47BF68C404FC60A18429B98A@ORSMSX102.amr.corp.intel.com>	 <1329968622.5143.46.camel@joe2Laptop>	 <804857E1F29AAC47BF68C404FC60A1842A1D36@ORSMSX102.amr.corp.intel.com> <1330108675.18464.21.camel@joe2Laptop>
In-Reply-To: <1330108675.18464.21.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 08:37 PM, Joe Perches wrote:
> Argument alignment across multiple lines should
> match the open parenthesis.
> 
> Logical continuations should be at the end of
> the previous line, not the start of a new line.
> 
> These are not required by CodingStyle so make the
> tests active only when using --strict.
> 
> Improved_by_examples_from: "Bruce W. Allen" <bruce.w.allan@intel.com>
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks Joe, this is very useful for me. I seem to have one false alarm
though:

drivers/net/wireless/ath/ath6kl/txrx.c:464: CHECK: Alignment should
match open parenthesis

This is with patches I haven't sent yet so line numbers most likely
don't match, but the code in question is this:

	if (!IS_ALIGNED((unsigned long) skb->data - HTC_HDR_LENGTH, 4) &&
	    skb_cloned(skb)) {

Apparently the cast "(unsigned long)" causes the false alarm as when I
remove it I don't see the warning anymore.

Kalle
