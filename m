Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2DCSRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:17:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32991 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab2DCSRc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <201203310924.19708.arnd@arndb.de>
References: <201203301744.16762.arnd@arndb.de>
	<201203301850.22784.arnd@arndb.de>
	<CAJN=5gDBQJc_KXUadqtzmxPqPF71PDcToGo_T-agNey9eN2MQA@mail.gmail.com>
	<201203310924.19708.arnd@arndb.de>
Date: Tue, 3 Apr 2012 13:17:30 -0500
Message-ID: <CAJN=5gD-_Us6XpZWBWm72c5byytLLYmwW-FeA+a48YxZeWeMtw@mail.gmail.com>
Subject: Re: swap on eMMC and other flash
From: Zach Pfeffer <zach.pfeffer@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org, linux-mm@kvack.org,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Hyojin Jeong <syr.jeong@samsung.com>,
        "Luca Porzio (lporzio)" <lporzio@micron.com>, kernel-team@android.com,
        Yejin Moon <yejin.moon@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2012 04:24, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 30 March 2012, Zach Pfeffer wrote:
>> Last I read Transparent Huge Pages are still paged in and out a page
>> at a time, is this or was this ever the case? If it is the case should
>> the paging system be extended to support THP which would take care of
>> the big block issues with flash media?
>>
>
> I don't think we ever want to get /that/ big. As I mentioned, going
> beyond 64kb does not improve throughput on most flash media. However,
> paging out 16MB causes a very noticeable delay of up to a few seconds
> on slow drives, which would be inacceptable to users.
>
> Also, that would only deal with the rare case where the data you
> want to page out is actually in huge pages, not the common case.

What I had in mind was being able to swap out big contiguous buffers
used by media and graphics engines in one go. This would allow devices
to support multiple engines without needing to reserve contiguous
memory for each device. They would instead share the contiguous
memory. Only one multimedia engine could run at a time, but that would
be an okay limitation given certain application domains (low end smart
phones).

>
>        Arnd



-- 
Zach Pfeffer
Android Platform Team Lead, Linaro Platform Teams
Linaro.org | Open source software for ARM SoCs
Follow Linaro: http://www.facebook.com/pages/Linaro
http://twitter.com/#!/linaroorg - http://www.linaro.org/linaro-blog
