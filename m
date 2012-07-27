Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2G0Kk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:40:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48382 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2G0KkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <5009A402.2060601@canonical.com>
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
 <5006D86C.7030208@canonical.com> <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
 <500832D7.4040805@canonical.com> <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
 <50084529.2030001@canonical.com> <20120719184419.GA3626@polaris.bitmath.org>
 <CAM2ehZaLeJsxCOkqLv9jSko9y3Awix1jjobfTo5WQj8rcrYquA@mail.gmail.com>
 <20120720072510.GA986@polaris.bitmath.org> <CAGS+omBmkdrpLds4xE==BNp1yctOmA1xj-p2s4S8Bvh7Q=ixxw@mail.gmail.com>
 <5009A402.2060601@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 27 Jul 2012 18:40:02 +0800
X-Google-Sender-Auth: IkRh6v1Gb2ZshLNdku11zk7K5-U
Message-ID: <CAGS+omCAQm-5ybbHwEr+ktAnu=+bvr9rVvP+70vudnn2Ui5ZxQ@mail.gmail.com>
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        =?UTF-8?B?IkNodW5nLVlpaCBXYW5nICjnjovltIfmh78pIg==?= 
	<cywang@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 2:31 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
>
> On 07/20/2012 02:03 AM, Daniel Kurtz wrote:
>>>>>>
>>>>>> * Leave the device as SEMI_MT, but provide the real locations, and
>>>>>> allow userspace to determine the device vendor/model/etc. If
>>>>>> userspace knows that a specific device behaves in a specific way, it
>>>>>> can do its own quirking handling. Given the specificity of this
>>>>>> behavior to only some devices of one brand, this would be my
>>>>>> suggested resolution to the issue.
>>
>>
>> This is essentially what this patch does.  It sets the SEMI_MT flag to
>> indicate that the kernel data cannot be totally trusted, and then
>> provides real MT-B (including per-finger pressures), instead of a
>> fixed bounding box.  It leaves it to userspace to treat the two slots
>> worth of coordinates as a bounding box or as actual fingers using its
>> own heuristics.  By limiting to only one hardware type (using DMI),
>> any breakage caused by this alternative use of the SEMI_MT flag is
>> limited.
>
>
> So I was worried that you were trying to remove the SEMI_MT flag, and I apologise for not looking closely enough to notice that wasn't the case. The documentation for the flag says:
>
> """
> Some touchpads, most common between 2008 and 2011, can detect the presence of multiple contacts without resolving the individual positions; only the number of contacts and a rectangular shape is known. For such touchpads, the semi-mt property should be set.
>
> Depending on the device, the rectangle may enclose all touches, like a bounding box, or just some of them, for instance the two most recent touches. The diversity makes the rectangle of limited use, but some gestures can normally be extracted from it.
> """
>
> Since the documentation doesn't say the data must be provided as min/max values, this patch actually appears to be perfectly fine as is.
>
> My next question is: how are you going to tell from userspace if the hardware actually provides correct data? IIRC, it was decided that we wouldn't provide sysfs nodes for the device IDs.
>

Excellent question.  We haven't solved this in any elegant way.  When
building images for this particular hardware platform, we set a flag
in our user-space touchpad driver.  It then knows to process this
device's data as "non-bounding box semi-mt".

-Daniel

> -- Chase
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
