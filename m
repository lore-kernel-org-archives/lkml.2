Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156Ab2KCAWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:22:20 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:42072 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753141Ab2KCAWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:22:17 -0400
Message-ID: <509463B1.8070108@virtuousgeek.org>
Date: Fri, 02 Nov 2012 17:22:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC] Suspend/resume without VT switches
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org> <7608326.fQBj17U8Wv@vostro.rjw.lan> <20121102162937.1ec88cf1@jbarnes-desktop> <2324361.keTRK1rkYL@vostro.rjw.lan>
In-Reply-To: <2324361.keTRK1rkYL@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2012 4:38 PM, Rafael J. Wysocki wrote:
> On Friday, November 02, 2012 04:29:37 PM Jesse Barnes wrote:
>> On Fri, 02 Nov 2012 22:51:07 +0100
>> "Rafael J. Wysocki"<rjw@sisk.pl>  wrote:
>>
>>> On Friday, November 02, 2012 02:43:39 PM Jesse Barnes wrote:
>>>> I've lightly tested this with X and it definitely makes my
>>>> suspend/resume sequence a bit prettier.  It should speed things up
>>>> trivally as well, but most of those gains come from other changes to the
>>>> i915 driver (posted earlier to intel-gfx).
>>>>
>>>> Any thoughts?
>>>
>>> I like the idea.
>>>
>>>> I suspect we'll have to be more defensive about the
>>>> resume configuration in case the BIOS did something weird, but overall I
>>>> think we should be able to do this one way or another.
>>>
>>> Perhaps patch [1/2] should be [2/2] and vice versa? :-)
>>
>> But then it wouldn't compile?  I added the variable first, defaulting
>> to the current behavior, then made i915 support it and set the variable
>> to false there...  At least, that's what I intended to do.
>
> OK
>
> So what happens if there are multiple graphics adapters in the system?
> Including such that aren't handled by i915?  pm_vt_switch is global, so isn't
> there any problem with that?

Yeah I guess it depends on configuration.  Maybe only the driver that's 
currently driving the VT should be able to set this, then clear it if 
it's no longer in charge?  Not sure how to do that yet (ugg means I get 
to dig into the console layer again...)

Thanks,
Jesse

