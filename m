Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0KCTCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:02:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35099 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0KCTCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <201011031357.37976.sgrubb@redhat.com>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com>
	<201011031300.31522.sgrubb@redhat.com>
	<1288805913.2939.53.camel@localhost.localdomain>
	<201011031357.37976.sgrubb@redhat.com>
Date: Wed, 3 Nov 2010 15:02:11 -0400
Message-ID: <AANLkTi=MiQsBvdtcr+isqagDYzKOFH0QVb9P=6aAxWVv@mail.gmail.com>
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
From: Eric Paris <eparis@parisplace.org>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 1:57 PM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, November 03, 2010 01:38:33 pm Mimi Zohar wrote:
>> > > As long as we're making this change, should 'security' also be defined
>> > > outside of the __kernel__ definitions?
>> >
>> > I guess no one fixed this before 2.6.36 was finalized. Removing the
>> > define has broke user  space compilation for anything that works on file
>> > based capabilities. I can define it myself, but if the kernel folks ever
>> > change the string, then we have more than just a compile problem, we
>> > have runtime problems because I can no longer use the correct string.
>> >
>> > So, what was the gain for breaking user space?
>> >
>> > -Steve
>>
>> Sorry I dropped the ball. Was expecting some kind of response to my
>> question above, and then forgot about it.
>>
>> All of the 'security' xattrs were moved to fsmagic.h, including
>> capability. Not only those that EVM protects, but others like
>> XATTR_NAME_SMACKIPIN/OUT (based on Casey's request).
>
> If user space has to know the exact contents of a string in order to do something that
> the kernel understands, then its part of a public API. I've made my own define and
> released a new copy of libcap-ng. So, if the contents of the string ever change, or
> becomes deprecated, you'll now have user space apps using the old values no matter
> what.

You're right Steve, it is ABI, we broke it, and we can fix it.  What
are you having to define and what are you including.  What files did
you used to get these defines from?

-Eric
