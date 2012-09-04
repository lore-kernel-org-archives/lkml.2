Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2IDPwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:52:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2IDPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <s5hd3222azc.wl%tiwai@suse.de>
References: <s5hd3222azc.wl%tiwai@suse.de>
Date: Tue, 4 Sep 2012 23:52:15 +0800
Message-ID: <CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
Subject: Re: A workaround for request_firmware() stuck in module_init
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 9:06 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Hi,
>
> as I've got recently a few bug reports regarding the stuck with
> request_firmware() in module_init of some sound drivers, I started
> looking at the issue.  Strangely, the problem doesn't happen on
> openSUSE 12.2 although it has the same udev version with libkmod as
> Fedora.  So I installed Fedora 17, and indeed I could see a problem
> there.

It should be a bug in udev, as discussed in the below link:

          http://marc.info/?t=134552745100002&r=1&w=2

>
> Obviously a solution would be to rewrite the driver code to use
> request_firmware_nowait() instead.  But it'd need a lot of code
> shuffling, and most of such drivers are old stuff I don't want to do a
> serious surgery.
>
> So I tried an easier workaround by using the deferred probing.
> An experimental patch is below.  As you can see, from the driver side,
> it's simple: just add two lines at the head of each probe function.

In fact, the defer probe should only be applied in situations which
driver is built in kernel and request_firmware is called in .probe().

>
> Do you think this kind of hack is OK?  If not, any better (IOW easier)
> solution?

Looks your solution is a bit complicated, and I have wrote a similar
patch to address the problem, but Linus thought that it may hide the
problem of drivers.

        http://marc.info/?t=134278790800004&r=1&w=2

IMO, driver core needn't to be changed, and the defer probe can be
supported just by changes in request_firmware() and its caller.

Thanks,
--
Ming Lei
