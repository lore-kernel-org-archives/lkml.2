Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2CaJYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:24:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2CaJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:24:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Zach Pfeffer <zach.pfeffer@linaro.org>
Subject: Re: swap on eMMC and other flash
Date: Sat, 31 Mar 2012 09:24:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linaro-kernel@lists.linaro.org, linux-mm@kvack.org,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Hyojin Jeong <syr.jeong@samsung.com>,
        "Luca Porzio (lporzio)" <lporzio@micron.com>, kernel-team@android.com,
        Yejin Moon <yejin.moon@samsung.com>
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de> <CAJN=5gDBQJc_KXUadqtzmxPqPF71PDcToGo_T-agNey9eN2MQA@mail.gmail.com>
In-Reply-To: <CAJN=5gDBQJc_KXUadqtzmxPqPF71PDcToGo_T-agNey9eN2MQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203310924.19708.arnd@arndb.de>
X-Provags-ID: V02:K0:DWmoYYWCqt7yqv8pNhCWNiys2XKLnz0rA3TRwRxtYwm
 daqrQO6WTZekjj5m8ORUlsuX1tdnlWS09eFtRq50hZ07gRBXcZ
 jl7ZRmbPSkeDmv0jPFmb1GOJ93e7DuQUbTakQZ8oJJiHa+Aezs
 iOxusC4CoW+WOic/2Jtz8rrQwo6YQt5Xu0fYGzDvV7cmi3gcTk
 oaSCZ+6yCd+1CB6Ly6Dd3n1X+QkKDazGH4+Jfy0s5fQ61JINIZ
 XkmcZkBVcW2y83lL+SZFOWcwk4PXFRCdnpI/BTkzAqVNbToOHm
 5Ob+0qg3LeTAaGkh78Nd0JOk8U+hzgMugibafnvxV133F8i5NF
 ROr/fwyv9ZNxc6UyKeow=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 March 2012, Zach Pfeffer wrote:
> Last I read Transparent Huge Pages are still paged in and out a page
> at a time, is this or was this ever the case? If it is the case should
> the paging system be extended to support THP which would take care of
> the big block issues with flash media?
> 

I don't think we ever want to get /that/ big. As I mentioned, going
beyond 64kb does not improve throughput on most flash media. However,
paging out 16MB causes a very noticeable delay of up to a few seconds
on slow drives, which would be inacceptable to users.

Also, that would only deal with the rare case where the data you
want to page out is actually in huge pages, not the common case.

	Arnd
