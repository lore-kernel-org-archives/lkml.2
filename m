Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1DRW6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:58:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65273 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1DRW5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hbPa7MSwcgnv98xUa0bxV1xkMzcpbnJyaBjNMUqP7ClcxckC4jts1xtJwv230AgFHq
         e7IH+SSQLrTmwyQTPyWoP0PButqzzVZJXl0AtaAdf2fuY2ov58HSSRpsSL2d00wtJSM8
         VIPxq05BhnjFCXy9vjQzAm12DJ4NXxoc2ZDOE=
MIME-Version: 1.0
In-Reply-To: <87tye1ckhr.fsf@linux.vnet.ibm.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com> <87tye1ckhr.fsf@linux.vnet.ibm.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 19 Apr 2011 00:57:27 +0200
Message-ID: <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:20, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, 12 Apr 2011 15:21:03 -0400, Dave Jones <davej@redhat.com> wrote:
>> On Tue, Apr 12, 2011 at 03:09:34PM -0400, Dave Jones wrote:
>>
>>  > however, the output of mount looks very confused..
>>  >
>>  > .38:
>>  > /dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
>>  >
>>  > .39:
>>  > - on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)
>>  >
>>  > It looks like /proc/self/mountinfo broke abi.
>>  >
>>  > .38:
>>  > 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
>>  >
>>  > .39:
>>  > 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered
>>
>> looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f
>>
>> perhaps adding that string to the end of the line would preserve what mount expects ?
>
> uuid:<value> is the option field  as per
> Documentation/filesystem/proc.txt. There was an error in libmount
> parsing which got fixed upstream recently

Just a simple question about this approach in general? A filesystem
UUID can be changed on disk at any time (tune2fs -U ...).

Your code looks like you copy the bytes to the in-kernel superblock
structure without noticing any later changes on disk? How is that
supposed to work?

Kay
