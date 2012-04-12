Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab2DLAiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:38:51 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50970 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761479Ab2DLAiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120412003014.GB23167@kroah.com>
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com> <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120411235311.GA11310@kroah.com> <4F8619FD.1080402@zytor.com> <20120412003014.GB23167@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 12 Apr 2012 02:38:29 +0200
Message-ID: <CAPXgP12iMFrsk2pq54sBuQL4jk_vGJS2AxW0HjkU5wjhv1Wskw@mail.gmail.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
To: Greg Kroah-Hartman <gregkh@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 02:30, Greg Kroah-Hartman
<gregkh@linux-foundation.org> wrote:
> On Wed, Apr 11, 2012 at 04:55:41PM -0700, H. Peter Anvin wrote:
>> On 04/11/2012 04:53 PM, Greg Kroah-Hartman wrote:
>> >
>> > That all seems pretty simple.
>> >
>> >>   - get rid of the (rather broken) idea of 'legacy' vs 'non-legacy mode'
>> >>     mount options in the default setup; I don't think userspace should
>> >>     ever be required to fiddle with such stuff
>> >
>> > Hm, but if we get rid of them, what about tools that expect them to be
>> > there?  Just silently ignore them?
>> >
>>
>> Drop the newinstance mount option on the floor; keep recognizing the
>> ptmxmode mount option but change the default.
>
> Wait, change the default to what?

Of the devpts fs mount option. The 'newinstance' one, which should not
have existed in the first place.

> I think this is going to require a lot of testing :)

In the example patch I posted and which I ran here, I just removed the
entire option. This was just to show that userspace does not want to
be taught dirty tricks that need updating of early-boot tools. All
such pretty self-contained stuff should be in the kernel itself.
Userspace wants to be dumb here, and that worked fine so far with that
patch. :)

Kay
