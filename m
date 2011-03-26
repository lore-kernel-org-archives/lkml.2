Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1CZR4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:56:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50184 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1CZR4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XoDZEaph6TKoHZ4ZdiDnM3VF/Rxd6k1d5Rfwp5iK+4OFG+vnJENY+EhwTdOoruSXQd
         Dw+1nj+kLtLUOQLp9a38TjZK2eR3V4NkAB7uA9xL96V27MhBC2fSPZAHp2JG0P0cYYHN
         wUSMWL5Xfh6HL3rE0e6LoLKhBHcmop9j5rulg=
MIME-Version: 1.0
In-Reply-To: <201103261154.18619.arnd@arndb.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <20110326002159.GY3130@pulham.picochip.com> <AANLkTinYd+4vtSBmBGHJwbCgFiZttSTtgQaQ0txwoUxt@mail.gmail.com>
 <201103261154.18619.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 26 Mar 2011 13:55:39 -0400
X-Google-Sender-Auth: 9G7ME7zPIUevh1wQO8mw4YlWyAU
Message-ID: <AANLkTik7qzFC_WQPrJAMbV0b6-+CTNfP6CcQnK6BKiWn@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 06:54, Arnd Bergmann wrote:
> On Saturday 26 March 2011 03:16:48 Mike Frysinger wrote:
>> On Fri, Mar 25, 2011 at 20:21, Jamie Iles wrote:
>> > For the actual ioctl() we should assume byte addressing rather than
>> > words though and do the conversion in the driver so we can cope with
>> > devices that don't have 64-bit words and do the locking on a looping
>> > word-by-word basis.
>> >
>> >        struct otp_lock_req {
>> >                __u32   start_addr;
>> >                __u32   byte_count;
>> >        };
>
> Looks good to me.
>
>> i would add an ABI field here too so if in the future we want to add
>> stuff, we can do so without adding new ioctls.  like "u16 version; u16
>> flags;".  then in the ioctl, if version isnt 0, we return ENOTSUP.  in
>> the future, we can add flags or bump the version.
>
> No, versioned APIs are just a pain to maintain, it's easier to add
> new ioctl commands when necessary.
> Note that the kernel would always have to support all versions of
> the API anyway.

adding at least a flags field then should be fine
-mike
