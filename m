Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1J0JnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:43:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42906 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1J0JnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:43:23 -0400
MIME-Version: 1.0
In-Reply-To: <20111027090507.GA5213@suse.de>
References: <CAJSP0QWV9V7JzCcJROF9_Psib3kC0f67c2OwZzJbxPmZn9SBJg@mail.gmail.com>
	<20111027090507.GA5213@suse.de>
Date: Thu, 27 Oct 2011 10:43:21 +0100
Message-ID: <CAJSP0QWJOODix7xR9JjUsB9XpYinwJ1Mk+GfO9649HGUd92dzQ@mail.gmail.com>
Subject: Re: staging: line6 driver status
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Markus Grabner <grabner@icg.tugraz.at>
Cc: devel@linuxdriverproject.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 10:05 AM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Oct 27, 2011 at 09:28:59AM +0100, Stefan Hajnoczi wrote:
>> What is the status of the line6 staging driver?  There is no TODO file
>> so I'm not sure what is blocking it from leaving staging.
>
> That's a good question.  I don't really know the status of the driver at
> the moment, does anyone else?

I have one question about the design of the driver:

Do we really need the sysfs attributes which boil down to MIDI
commands?  I think a userspace library provides a better interface
because the MIDI commands/values vary between device models and bloat
the driver.  Generic sound recording and MIDI software would talk to
the driver.  Utilities to control the device could link against the
userspace library.

By splitting the code into the kernel MIDI/pcm driver and a userspace
control library which uses MIDI we can slim down the kernel driver and
leave the large variation of MIDI commands/values to a library that
the community can improve for specific device models.

This will make the driver smaller and easier for review.

Stefan
