Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2FHHdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:33:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52053 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2FHHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:33:19 -0400
Message-ID: <4FD1AABD.7010602@gmail.com>
Date: Fri, 08 Jun 2012 03:33:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: leonid.moiseichuk@nokia.com
CC: kosaki.motohiro@gmail.com, anton.vorontsov@linaro.org, penberg@kernel.org,
        b.zolnierkie@samsung.com, john.stultz@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
References: <20120601122118.GA6128@lizard> <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org> <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard> <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com> <CAHGf_=rHGotkPYJt65wv+ZDNeO2x+3c5sA8oJmGJX8ehsMHqoA@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045F78E1@008-AM1MPN1-004.mgdnok.nokia.com> <CAHGf_=pNJAQP4GhTwtOkBxUDYU4n_-CKmKU7T4PzszwdL9Ju6Q@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045F7918@008-AM1MPN1-004.mgdnok.nokia.com>
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045F7918@008-AM1MPN1-004.mgdnok.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/8/12 3:28 AM), leonid.moiseichuk@nokia.com wrote:
>> -----Original Message-----
>> From: ext KOSAKI Motohiro [mailto:kosaki.motohiro@gmail.com]
>> Sent: 08 June, 2012 10:23
> ...
>>> If you wakeup only by signal when memory situation changed you can be
>> not mlocked.
>>> Mlocking uses memory very inefficient way and usually cannot be applied
>> for apps which wants to be notified due to resources restrictions.
>>
>> That's your choice. If you don't need to care cache dropping, We don't
>> enforce it. I only pointed out your explanation was technically incorrect.
>
> My explanation is correct. That is an overhead you have to pay if start to
>use API based on polling from user-space and this overhead narrows API
>applicability.
> Moving all times/tracking to kernel avoid useless wakeups in user-space.

Wrong. CPU don't realized the running code belong to userspace or kernel. Every
code just consume a power. That's why polling timer is wrong from point of power
consumption view.

