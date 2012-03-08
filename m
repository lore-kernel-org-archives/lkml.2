Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2CHSYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:24:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2CHSYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:24:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120308173306.GA4456@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
	<1331170478-30538-6-git-send-email-john.stultz@linaro.org>
	<20120308024203.GA25842@kroah.com>
	<CAMbhsRRDmH47r_s_-H+tnZ62c9HdE3VqeTn5Qp4kwe5EOjJ4jw@mail.gmail.com>
	<20120308173306.GA4456@kroah.com>
Date: Thu, 8 Mar 2012 10:24:11 -0800
X-Google-Sender-Auth: afzVhjkTyaslDWXJblhlCiE_qO0
Message-ID: <CAMbhsRQL=JrJ-a97KhbhHF5J_hD74f7wp1bVtx-n0hgQX_B3oA@mail.gmail.com>
Subject: Re: [PATCH 05/11] android: ram_console: split out persistent ram
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 9:33 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 07, 2012 at 07:06:42PM -0800, Colin Cross wrote:
>> On Wed, Mar 7, 2012 at 6:42 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Mar 07, 2012 at 05:34:32PM -0800, John Stultz wrote:
>> >> From: Colin Cross <ccross@android.com>
>> >>
>> >> Split ram_console into two halves.
>> >>
>> >> persistent_ram is a set of apis that handle a block of memory
>> >> that does not get erased across a reboot.  It provides functions
>> >> to fill it as a single buffer or a ring buffer, and to extract
>> >> the old data after a reboot.  It handles ecc on the data to
>> >> correct bit errors introduced during reboot.
>> >
>> > That's a nice idea, but why are you rolling your own interface here and
>> > not using the built-in one that the kernel already provides?  Is there
>> > something lacking with what we have today that requires you to create
>> > something different?  If so, why not just modify the existing interface
>> > to make it work for you, that way the tools already created will work
>> > automatically, and you will not have problems later ripping this out and
>> > porting it to the in-kernel api.
>>
>> What interface are you referring to, pstore?
>
> Yes.
>
>> As I explained in the email John quoted to you,
>
> Wait, what email?  Did I miss a response here?  Have a message-id: I can
> search for?

Message ID 1331160054.2191.202.camel@work-vm

>> pstore would be a client of this, and ramconsole could be moved on top
>> of pstore.
>
> Ok, as long as that is the end goal, that's fine, it was not obvious
> that this was the case at all, hence my confusion.
>
>> This patch is just a refactoring that splits ramconsole and the
>> persistent storage apart without significantly changing the api
>> between them, and only makes it easier to insert pstore between them.
>
> That's good to hear, I'll go queue them up then, thanks for clearing
> this up.
>
> greg k-h
