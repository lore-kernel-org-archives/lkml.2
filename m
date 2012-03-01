Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2CAJUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:20:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62892 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965582Ab2CAJUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:20:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of corentin.chary@gmail.com designates 10.204.133.216 as permitted sender) smtp.mail=corentin.chary@gmail.com; dkim=pass header.i=corentin.chary@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120229225650.GD20565@ubuntu-macmini>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
	<1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
	<CACxGe6sAcubJvc6LaVRxt+XzBz0jKpxSAPLdOvXkQz=NkXG5vQ@mail.gmail.com>
	<20120229175327.GA20565@ubuntu-macmini>
	<CACxGe6uc+LZjuMLS5DZELzAsHsnhObL6mdPzdMnNVbfriTfNwg@mail.gmail.com>
	<20120229195042.GB20565@ubuntu-macmini>
	<CACxGe6tK85FgYAT-1JQbLxEhRS34v2MPsx8urXADi6v2FnQ2gw@mail.gmail.com>
	<20120229220809.GC20565@ubuntu-macmini>
	<CACxGe6tLCYhuiAH1Q1PoWTzFLmZ0watw==0g76J1hS-Qurzyrw@mail.gmail.com>
	<20120229225650.GD20565@ubuntu-macmini>
Date: Thu, 1 Mar 2012 10:19:58 +0100
Message-ID: <CAHR064ikTm5dD-R6JE84XUTzNH5fRz9Xi4uKaK9cMn=MkrxCHg@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
From: Corentin Chary <corentin.chary@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:56 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Feb 29, 2012 at 04:32:28PM -0600, Grant Likely wrote:
>> On Wed, Feb 29, 2012 at 4:08 PM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > On Wed, Feb 29, 2012 at 03:23:20PM -0600, Grant Likely wrote:
>> >> On Wed, Feb 29, 2012 at 1:50 PM, Seth Forshee
>> >> <seth.forshee@canonical.com> wrote:
>> >> > On Wed, Feb 29, 2012 at 12:43:23PM -0600, Grant Likely wrote:
>> >> >> On Wed, Feb 29, 2012 at 11:53 AM, Seth Forshee
>> >> >> <seth.forshee@canonical.com> wrote:
>> >> >> > On Wed, Feb 29, 2012 at 11:46:39AM -0600, Grant Likely wrote:
>> >> >> >> On Wed, Feb 22, 2012 at 8:37 AM, Seth Forshee
>> >> >> >> <seth.forshee@canonical.com> wrote:
>> >> >> >> > Apple laptops with hybrid graphics have a device named gmux that
>> >> >> >> > controls the muxing of the LVDS panel between the GPUs as well as screen
>> >> >> >> > brightness. This driver adds support for the gmux device. Only backlight
>> >> >> >> > control is supported initially.
>> >> >> >> >
>> >> >> >> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> >> >> >>
>> >> >> >> Works for me.
>> >> >> >>
>> >> >> >> Tested-by: Grant Likely <grant.likely@secretlab.ca>
>> >> >> >>
>> >> >> >> Now I just need to figure out how to get the desktop backlight widget
>> >> >> >> to use gmux_backlight instead of acpi_video0...
>> >> >> >
>> >> >> > The easy way is to pass acpi_backlight=vendor to the kernel, then you
>> >> >> > won't have acpi_vidoe0.
>> >> >>
>> >> >> That did it, thanks.  I'm assume something is in the works to set it
>> >> >> up automatically?
>> >> >
>> >> > Not that I'm aware of. A number machines have this problem, that the
>> >> > standard ACPI backlight interfaces are implemented but don't work. This
>> >> > generally isn't detectable in software; with the Apples at least
>> >> > everything looks like it's working except that the brightness doesn't
>> >> > change (but not all Apple laptops are affected, so qurking based on
>> >> > manufacturer wouldn't work). All we're left with is DMI quirking, which
>> >> > isn't practical. Maybe we could add something so a platform driver can
>> >> > tell acpi_video that it knows the ACPI backlight doesn't work, but I
>> >> > think on some platforms that still is going to be based off of DMI
>> >> > information.
>> >>
>> >> blacklisting based on specific product name (ie. MacBookPro8,*) or
>> >> machine model is probably the best.  It wouldn't be the first
>> >> blacklist in the linux kernel.
>> >
>> > I think the blacklist would have to be against specific product names.
>> > For example, the MacBook Pro 8,1 has a working acpi_video backlight and
>> > no gmux_backlight, the 8,2 has both but only gmux_backlight works, and I
>> > suspect the 8,3 is the same as the 8,2.
>>
>> I have the 8,3, and my testing confirms that.
>>
>> > We'd probably end up with an
>> > entry in the blacklist for every single model whose acpi_video backlight
>> > doesn't work, adding entries for each new generation of MacBooks.
>> >
>> > And if we start blacklisting Macs we'd have start doing it for other
>> > machines too, I guess. From what I've seen, open-ended blacklists like
>> > this get nacked pretty consistently nowadays.
>>
>> An alternative would be to blacklist or disable acpi0_backlight when
>> the apple-gmux driver loads.  I don't know how acceptable that is, but
>> I also don't have much sympathy for nacking blacklists if there isn't
>> a viable alternative.
>
> Yes, that's one idea I was thinking about. For all the machines I've
> been able to get tested, if the gmux is present then it can control the
> backlight and acpi_video cannot, so that approach is reasonable for
> Macs.
>
> There are quite a few machines in this situation though, and whatever
> solution is arrived at should be flexible enough to work beyond just
> Macs. I'll try to find some time soon to explore this further and see if
> I can come up with something.

Old Samsung laptops have the same issue, and I ended up patching
drivers/acpi/video_detect.c (check "[PATCH] ACPI / Video: blacklist
some samsung laptops").
Doing it in the vendor module is complicated, since, it will be loaded
after the acpi video module most of the time, and that means addding
acpi_backlight, then removing it, which will probably confuse
usespace.
Patching drivers/acpi/video_detect.c seems safer.

-- 
Corentin Chary
http://xf.iksaif.net
