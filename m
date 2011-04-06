Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1DFIu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:50:56 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:33532 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab1DFIuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:50:54 -0400
Message-ID: <4D9C2910.6020309@stericsson.com>
Date: Wed, 6 Apr 2011 10:49:20 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv5 1/3] ARM: Translate delay.S into (mostly) C
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org> <1302047800-26720-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1302047800-26720-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 01:56 AM, Stephen Boyd wrote:
> +void __udelay(unsigned long usecs)
> +{
> +	__const_udelay(usecs * ((2199023*HZ)>>11));
This will overflow if HZ=1000.
If I remember correct I fixed it like this:
__const_udelay(usecs * ((2199023UL*HZ)>>11));

/Mattias Wallin
