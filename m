Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab2EJMPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:15:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45014 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab2EJMPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120509194623.GA12381@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
	<1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
	<20120506190322.GB12571@polaris.bitmath.org>
	<CAN+gG=HQ_U5dhVvgLu0zfMjv1+SAVB2Rx8fNq8tLX2DUHOMa9A@mail.gmail.com>
	<20120509194623.GA12381@polaris.bitmath.org>
Date: Thu, 10 May 2012 14:15:31 +0200
Message-ID: <CAN+gG=Fyq7S54rkDRsUmEytxcU-HQb68qENnED8=xaUxF3-BXQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] HID: hid-multitouch: get maxcontacts also from
 logical_max value
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 9:46 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> >> Win8 devices are required to present the feature "Maximum Contact Number".
>> >> If the current value is 0, then, the driver can get the actual supported
>> >> contact count by seeing the logical_max.
>> >
>> > And for win7, it is zero?
>>
>> Well, the truth is that the Win8 specification formally describes the
>> values here. And to get the certification, hardware makers have to put
>> the right value in logical_max.
>> TBH, I don't care that much now with win7 devices. Most of them are a
>> piece of crap (not true dual fingers, problems in hid reports
>> descriptors, etc...), but they just work (we made the necessary
>> things). With the introduction of Win8, hardware makers will have to
>> *certify* their devices, and thus, the Win8 driver is much less
>> tolerant. I really think that we are going to see more and more win8
>> devices, whereas win7 devices will fade out.
>>
>> I had to add this patch because I have a win8 device that has the
>> value associated to this field at 0, and it's the first I saw with
>> this behavior.
>
> As long as all existing devices are unaffected, it's fine, hence the question.

I checked all the reports descriptors that I have.
2 devices (one Stantum and one Irtouch) present an unrealistic
logical_max value (255). The thing is that if this logical_max is
false, and if the value is not provided, then I don't know how could I
retrieve the right value beside introducing a MT_CLS...

Henrik, do you think that 255 is two much for the slots?

Thanks,
Benjamin

>
> Thanks,
> Henrik
