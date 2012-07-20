Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2GTSbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:31:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2GTSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:31:35 -0400
Message-ID: <5009A402.2060601@canonical.com>
Date: Fri, 20 Jul 2012 11:31:30 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120620 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Henrik Rydberg <rydberg@euromail.se>,
        =?UTF-8?B?IkNodW5nLVlpaCBXYW5nIA==?= =?UTF-8?B?KOeOi+W0h+aHvyki?= 
	<cywang@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
References: <1342606923-9997-1-git-send-email-cywang@chromium.org> <5006D86C.7030208@canonical.com> <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com> <500832D7.4040805@canonical.com> <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com> <50084529.2030001@canonical.com> <20120719184419.GA3626@polaris.bitmath.org> <CAM2ehZaLeJsxCOkqLv9jSko9y3Awix1jjobfTo5WQj8rcrYquA@mail.gmail.com> <20120720072510.GA986@polaris.bitmath.org> <CAGS+omBmkdrpLds4xE==BNp1yctOmA1xj-p2s4S8Bvh7Q=ixxw@mail.gmail.com>
In-Reply-To: <CAGS+omBmkdrpLds4xE==BNp1yctOmA1xj-p2s4S8Bvh7Q=ixxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 02:03 AM, Daniel Kurtz wrote:
>>>>> * Leave the device as SEMI_MT, but provide the real locations, and
>>>>> allow userspace to determine the device vendor/model/etc. If
>>>>> userspace knows that a specific device behaves in a specific way, it
>>>>> can do its own quirking handling. Given the specificity of this
>>>>> behavior to only some devices of one brand, this would be my
>>>>> suggested resolution to the issue.
>
> This is essentially what this patch does.  It sets the SEMI_MT flag to
> indicate that the kernel data cannot be totally trusted, and then
> provides real MT-B (including per-finger pressures), instead of a
> fixed bounding box.  It leaves it to userspace to treat the two slots
> worth of coordinates as a bounding box or as actual fingers using its
> own heuristics.  By limiting to only one hardware type (using DMI),
> any breakage caused by this alternative use of the SEMI_MT flag is
> limited.

So I was worried that you were trying to remove the SEMI_MT flag, and I 
apologise for not looking closely enough to notice that wasn't the case. 
The documentation for the flag says:

"""
Some touchpads, most common between 2008 and 2011, can detect the 
presence of multiple contacts without resolving the individual 
positions; only the number of contacts and a rectangular shape is known. 
For such touchpads, the semi-mt property should be set.

Depending on the device, the rectangle may enclose all touches, like a 
bounding box, or just some of them, for instance the two most recent 
touches. The diversity makes the rectangle of limited use, but some 
gestures can normally be extracted from it.
"""

Since the documentation doesn't say the data must be provided as min/max 
values, this patch actually appears to be perfectly fine as is.

My next question is: how are you going to tell from userspace if the 
hardware actually provides correct data? IIRC, it was decided that we 
wouldn't provide sysfs nodes for the device IDs.

-- Chase
