Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1DPOFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:05:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50031 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1DPOE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IW4BBz/MIg2vcPRjwjV5seJzHtq4ZaFMO2h2cT+k+An5LJS1Sip/O5DkZCXsPAzYjO
         VPmVizvlzsbJCONh077VVyino3Ugt7GgSj0RcXBXXxUb1CvpFW7Q4U7IohpZZo5Eu3Ix
         QMMiqHh+X9JPCo/qTPHf4grP6teZXu9SFGEkM=
MIME-Version: 1.0
In-Reply-To: <20110416135912.GA1044@merkur.ravnborg.org>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
	<20110416135912.GA1044@merkur.ravnborg.org>
Date: Sat, 16 Apr 2011 16:04:57 +0200
Message-ID: <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: Francis Moreau <francis.moro@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 16, 2011 at 3:59 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Apr 16, 2011 at 10:05:43AM +0200, Francis Moreau wrote:
>> Hello Sam,
>>
>> Maybe could suggest something, it would be great.
>>
>> Thanks
>>
>> On Thu, Apr 14, 2011 at 9:13 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> > Hello,
>> >
>> > I'm writing a script to automatise some parts of my kernel compilation process.
>> >
>> > From those scripts I'd like to be able to call the top makefile the
>> > same way it had been called during its last invocation.
>> >
>> > For example, if Ido:
>> >
>> >     $ make CC=my-gcc CFLAGS="-g -fwhatever"
>> >
>> > I would like to retrieve the "CC=my-gcc CFLAGS="-g -fwhatever" part of
>> > the last invocation so my script can call make with the same
>> > arguments.
>> >
>> > Is this possible ?
>
> There is nothing made in kbuild to preserve the value of randomly
> added variable assignments on the command-line.
>
> If you specify O=... then a Makfile file is generated in the output
> directory that thus emulate the O= setting.
>
> CCFLAGS has btw. no effect when you build a kernel.

Ok CCFLAGS was a poor example.

BTW are the allowed flags documented somewhere ?

> If you on a regular basis need to pass flags on the command-line
> then you likely are doing something odd as this is not the typical use.
> So please reconsider what you are doing.

Ok, if I'm doing something wrong, I'd like to be corrected.

What's wrong with passing those flags for example:

  $ make ARCH=arm CROSS_COMPILE=arm-linux

or

   $ make CC=distcc

?

> And you can as pointed out by Américo Wang always save the
> command line in your calling script.

No, because the makefile invocation is not always done by my script.

For example a user can do:

  $ make ARCH=arm CROSS_COMPILE=arm-linux-

Then call my script and expect it to pass the same flags to make.

Thanks
-- 
Francis
