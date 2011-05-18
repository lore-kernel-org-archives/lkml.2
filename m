Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1ERP4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:56:22 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:33534 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab1ERP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:56:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4DD3EC22.7060907@tremplin-utc.net>
Date: Wed, 18 May 2011 17:56:18 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110517 Mandriva/3.1.10-2 (2011.0) Thunderbird/3.1.10
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC v2] lis3lv02d: avoid divide by zero due to unchecked register
 read
References: <201105160046.31019.chunkeey@googlemail.com> <201105162336.05306.chunkeey@googlemail.com> <4DD2EC98.5080901@tremplin-utc.net> <201105181747.12356.chunkeey@googlemail.com>
In-Reply-To: <201105181747.12356.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 18-05-11 17:47, Christian Lamparter schreef:
> On Tuesday 17 May 2011 23:46:00 Éric Piel wrote:
>> Op 16-05-11 23:36, Christian Lamparter schreef:
>>> On Monday 16 May 2011 13:16:46 Éric Piel wrote:
:
>>> Do you know how "volatile" this data rate is? If it never changes
>>> [at least it doesn't here?] then why not read it once in init_device
>>> and store it in the device context?
>> It is not normally changing, normally it is set just at init/unsuspend
>> (where the bios can also interfere sometimes) and when the user changes
>> it.
> Uh, "bios can also interfere"... this sounds very bad. At least for
> my x41t the bios doesn't care about hdaps once the OS is running.
>
>> So definitely within the same function it's not going to suddenly
>> change.
> a SMM can happen at any time and if a faulty BIOS [likely, since I got
> a new laptop] is what caused the crash, I wouldn't bet on "const within
> a function context".
Yes, at least on the HP laptop I have the bios enjoys re-initialising 
the hardware at some default value whenever suspend/resume happens.


>> We could avoid calculating/checking it twice in
>> lis3lv02d_selftest(). Care to do a third version with this little clean up?
> I have my doubts, but ok if you say so... Just one thing: need to do some Q&A
> on the code above, I haven't tested it extensively yet.
I didn't know about the SMM... well, then let's keep the code as is.

I'll try to test it on my laptop in the coming days. On which hardware 
have you tested it?

Éric
