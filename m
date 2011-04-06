Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1DFWsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:48:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1DFWsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=B9dDjY3Q8hxJN15rJfKm6two6Ptoka2PeCksQh7IBmmr1PMWecQlNHtii9fUM1Ld+E
         lCtJ6YwycjaSqW+d8b6Q==
MIME-Version: 1.0
In-Reply-To: <4D9C477E.4050400@cam.ac.uk>
References: <1302057915-13549-1-git-send-email-sonnyrao@chromium.org> <4D9C477E.4050400@cam.ac.uk>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 6 Apr 2011 15:47:42 -0700
X-Google-Sender-Auth: 1UesnZIly2BRCOrgrb30fzBi804
Message-ID: <BANLkTikWBU-uW6xKwNt+zrS0JbDPOzdd0w@mail.gmail.com>
Subject: Re: [PATCH] Enable async suspend/resume on industrial IO devices
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-pm@lists.linux-foundation.org, bleung@chromium.org,
        snanda@chromium.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Phillip Kurtenbach <pkurtenbach@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 3:59 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 04/06/11 03:45, Sonny Rao wrote:
>> Industrial I/O devices can sometimes take a long time to resume,
>> allowing them to be asynchronus saves 50ms on one light sensor
>>
> Hi Sonny,
>
> cc'd linux-iio
>
> I'm not particularly familiar with this.  Are there any disadvantages?
> I just wonder if it would be better to push this into individual drivers
> rather than the core?

Yeah we could do it that way too, I sent out a similar patch for i2c
and people were asking if it was entirely safe.  It sounds like it may
depend on dependencies between devices.

Do you know if any of the devices in iio have inter-device dependencies?
I was under the impression they were mostly stand-alone sensors that
ordinarily wouldn't, but I haven't tried to audit all of them or anything.

Sonny
