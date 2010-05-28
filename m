Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0E1NdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:33:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65234 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0E1NdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <20100527171313.GB11358@wavehammer.waldi.eu.org>
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> 
	<20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org> 
	<20100527150251.GD6040@wavehammer.waldi.eu.org> <4BFEA2DF.8080006@msgid.tls.msk.ru> 
	<20100527171313.GB11358@wavehammer.waldi.eu.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 28 May 2010 15:24:40 +0200
Message-ID: <AANLkTinmhitag1oTssXB_ICXIriubGLNBvltS-Fuc8Cg@mail.gmail.com>
Subject: Re: [PATCH] Fix name of Xen event-channel device
To: Bastian Blank <waldi@debian.org>, Michael Tokarev <mjt@tls.msk.ru>,
       xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 19:13, Bastian Blank <waldi@debian.org> wrote:
> On Thu, May 27, 2010 at 08:50:39PM +0400, Michael Tokarev wrote:
>> Bastian Blank wrote:
>> > The Xen event-channel device is named evtchn in the kernel but always
>> > used as /dev/xen/evtchn in userspace. This patch fixes the name.
>> >
>> > Signed-off-by: Bastian Blank <waldi@debian.org>
>> >
>> > diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
>> > index 66e185c..89cd743 100644
>> > --- a/drivers/xen/evtchn.c
>> > +++ b/drivers/xen/evtchn.c
>> > @@ -471,7 +471,7 @@ static const struct file_operations evtchn_fops = {
>> >
>> >  static struct miscdevice evtchn_miscdev = {
>> >     .minor        = MISC_DYNAMIC_MINOR,
>> > -   .name         = "evtchn",
>> > +   .name         = "xen/evtchn",
>>
>> Um.  Will existing userspace - esp. udev rules - continue
>> to work after this change?
>
> The udev rules will just not longer match, as they only rename the
> device, this is no problem. However libxc _will_ break, as it lacks
> proper error check in its own device creation routine.
>
> However there are not much possibilities here: this support will go away
> and it will annoy every user for some time.
>
>>                             Also, how about other xen-related
>> devices which are moved to /dev/xen in that same udev rules?
>
> This is the only device currently supported by the vanilla kernel,
> everything else is in the Xen tree only.

And naming of primary device nodes is no longer udev's task. All these
rules are removed from the default udev rules. These names must all
come from the kernel these days. Udev will log errors if udev rules
specify names which are not in sync with the kernel, so they can be
fixed in the kernel or in the rules.

With devtmpfs the kernel needs to know all the names to create them on
its own. Udev only manages permissions, possibly creates additional
symlinks, runs programs, and distribute the events to userspace. Udev
no longer manages the naming of any primary device node.

Thanks,
Kay
