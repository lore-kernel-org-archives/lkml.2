Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1HRGIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:08:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63692 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1HRGID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:08:03 -0400
Message-ID: <4E4CABE5.7020900@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 14:06:29 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <4E4C80A0.8090708@cn.fujitsu.com> <87d3g347ey.fsf@emc.com.tw> <4E4CA3A9.2010900@cn.fujitsu.com> <CAGS+omB0Ys-vEVq64W85Jmsz=TkgvNqn_iJkxynZJr8wvqifGQ@mail.gmail.com> <4E4CA6B4.5060807@cn.fujitsu.com> <CAGS+omDT1WNBoC-T4zmKx1SnVofLwUdt-pfQDWGicO87xUBqxw@mail.gmail.com>
In-Reply-To: <CAGS+omDT1WNBoC-T4zmKx1SnVofLwUdt-pfQDWGicO87xUBqxw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 14:06:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 14:06:17,
	Serialize complete at 2011-08-18 14:06:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 02:01 PM, Daniel Kurtz wrote:
> On Thu, Aug 18, 2011 at 1:44 PM, Wanlong Gao<gaowanlong@cn.fujitsu.com>  wrote:
>> On 08/18/2011 01:34 PM, Daniel Kurtz wrote:
>>>
>>> On Thu, Aug 18, 2011 at 1:31 PM, Wanlong Gao<gaowanlong@cn.fujitsu.com>
>>>   wrote:
>>>>
>>>> On 08/18/2011 01:26 PM, JJ Ding wrote:
>>>>>
>>>>> Hi Wanlong Gao,
>>>>>
>>>>> On Thu, 18 Aug 2011 11:01:52 +0800, Wanlong
>>>>> Gao<gaowanlong@cn.fujitsu.com>
>>>>>   wrote:
>>>>>>
>>>>>> On 08/18/2011 09:57 AM, JJ Ding wrote:
>>>>>>>
>>>>>>> v3 hardware's packet format is almost identical to v2 (one/three
>>>>>>> finger
>>>>>>> touch),
>>>>>>> except when sensing two finger touch, the hardware sends 12 bytes of
>>>>>>> data.
>>>>>>>
>>>>>>> Signed-off-by: JJ Ding<jj_ding@emc.com.tw>
>>>>>>> ---
>>>>>>>    Documentation/input/elantech.txt |  104 ++++++++++++++++--
>>>>>>>    drivers/input/mouse/elantech.c   |  218
>>>>>>> ++++++++++++++++++++++++++++++++++---
>>>>>>>    drivers/input/mouse/elantech.h   |   11 ++
>>>>>>>    3 files changed, 303 insertions(+), 30 deletions(-)
>>>>>>>
>>>>>>> +static int determine_packet_v3(struct psmouse *psmouse)
>>>>>>
>>>>>> elantech_check_parity_v1
>>>>>> packet_simple_check_v2
>>>>>> determine_packet_v3
>>>>>>
>>>>>> Why not consistent them?
>>>>>
>>>>> OK, how do these names sound to you?
>>>>>
>>>>> elantech_check_parity_v1
>>>>> elantech_packet_check_v2
>>>>> elantech_packet_check_v3
>>>>>
>>>>> Thanks,
>>>>> jj
>>>>
>>>> Yeah, sounds perfectly.
>>>
>>> Or just:
>>>
>>> elantech_packet_check_v1
>>> elantech_packet_check_v2
>>> elantech_packet_check_v3
>>>
>>> :)
>>
>> Hmm... maybe they can go into an elantech_packet_check()?
>> like:
>> case 1:
>>         ...
>> case 2:
>>         ...
>> What do you think? ;)
>>
>> Thanks
>> -Wanlong Gao
>
> Since we've already parsed the hardware type at this point, it seems
> inefficient to parse it again inside another function.
> I would prefer individual functions.
>
> Thanks,
> -Daniel
>

Yeah, It makes sense.

Thanks
-Wanlong Gao
