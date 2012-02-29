Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2B2UBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:01:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41320 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284Ab2B2UBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:01:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of larry.finger@gmail.com designates 10.60.7.70 as permitted sender) smtp.mail=larry.finger@gmail.com; dkim=pass header.i=larry.finger@gmail.com
Message-ID: <4F4E83FD.3060506@lwfinger.net>
Date: Wed, 29 Feb 2012 14:01:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com, chunkeey@web.de,
        m@bues.ch, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC/RFT 5/5] p54spi: Load firmware from work queue and not from
 probe routine
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> <1329161826-11135-6-git-send-email-Larry.Finger@lwfinger.net> <4F4E4B8B.8090508@lwfinger.net> <CAMo8BfK5=YwZYepFoP5SqgDQMPvUeQobqNiBCMM5=eTwUT5e0A@mail.gmail.com>
In-Reply-To: <CAMo8BfK5=YwZYepFoP5SqgDQMPvUeQobqNiBCMM5=eTwUT5e0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 01:54 PM, Max Filippov wrote:
>>> Drivers that load firmware from their probe routine have problems with the
>>> latest versions of udev as they get timeouts while waiting for user
>>> space to start. The problem is fixed by loading the firmware and starting
>>> mac80211 from a delayed_work queue. By using this method, most of the
>>> original code is preserved.
>>>
>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>> ---
>>> This one is compile-tested only.
>>>
>>> Larry
>>> ---
>>
>>
>> Any testing done here?
>
> insmod immediately followed by rmmod causes NULL pointer dereference.
> The same always happens on rmmode when the firmware image is absent:

Thanks for testing.

Larry


