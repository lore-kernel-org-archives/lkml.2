Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1AFXyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:54:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49439 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1AFXyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <20110106222436.GA31994@suse.de>
References: <20110106215404.GA30624@kroah.com> <20110106220017.3c19f9e6@lxorguk.ukuu.org.uk>
 <20110106222436.GA31994@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Jan 2011 00:54:05 +0100
Message-ID: <AANLkTiman4=gGxMccUu41tvt19imiSvnhTe3wm9p-s2r@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY/serial merge for .38
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 23:24, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jan 06, 2011 at 10:00:17PM +0000, Alan Cox wrote:
>> > There was some arguing about the tty console detection patches, but as
>> > the existing ioctl does not work properly, Kay's patch was accepted to
>> > resolve this issue and allow systemd to correctly detect consoles.  I
>> > know Alan doesn't like this, but I feel it's the best way to solve the
>> > issue (combined with the fact that there is no proposed other solution.)
>>
>> I'm a bit confused about this one Greg - all the distributions used the
>> ioctl you refer to below for this purpose and have for years
>>
>> > This series also includes the long-out-of-tree ioctl that SUSE and
>> > Debian have been dragging around in their kernels for the past 10+
>> > years.  Thanks to Werner for finally submitting it in a mergable form.
>>
>> Which I believe means we don't need the sysfs patch as well - Kay ?
>
> I didn't think that the ioctl was sufficient for what systemd required,
> it was only needed for "old-style" initrd programs like what used to be
> used in SUSE and other distros, but are now being phased out.

We want all involved ttys below /dev/console not only the primary one.
Also we like to get notified about re-configs, hence the poll()
support. Both is not covered at the moment, or by the old, now to be
merged, ioctl.

Kay
