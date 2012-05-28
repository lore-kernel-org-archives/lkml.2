Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2E1V7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 17:59:19 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33587 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2E1V7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 17:59:17 -0400
Message-ID: <4FC3F530.6070906@lwfinger.net>
Date: Mon, 28 May 2012 16:59:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
        Neptune Ning <frostyplanet@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 89/94] rtlwifi: fix for race condition when firmware is cached
References: <20120527010332.GA11170@kroah.com> <20120527010436.309233153@linuxfoundation.org> <20120528202113.GD2915@herton-Z68MA-D2H-B3>
In-Reply-To: <20120528202113.GD2915@herton-Z68MA-D2H-B3>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 03:21 PM, Herton Ronaldo Krzesinski wrote:
> On Sun, May 27, 2012 at 10:05:52AM +0900, Greg KH wrote:
>> 3.3-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Larry Finger<Larry.Finger@lwfinger.net>
>>
>> commit 574e02abaf816b582685805f0c1150ca9f1f18ee upstream.
>>
>> In commit b0302ab, the rtlwifi family of drivers was converted to use
>> asynchronous firmware loading. Unfortumately, the implementation was
>> racy, and the ieee80211 routines could be started before rtl_init_core()
>> was called to setup the data.
>
> Shouldn't also 3.3 have another fix after b0302ab was applied to it,
> that is commit 0298dc9 ("rtlwifi: rtl8192de: Fix firmware initialization") ?
> I noted it is missing, cherry-picks cleanly here on 3.3

Yes, that patch could be applied to 3.3. I chose not to mark it as Cc Stable as 
that card is not widely available, thus I did not expect the problem to harm 
many users. On reflection, I think I made the wrong choice.

Greg, could you please apply mainline commit 0298dc9 to 3.3-stable?

Thanks,

Larry

