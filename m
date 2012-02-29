Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2B2Wcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:32:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41344 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353Ab2B2Wcs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:32:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.122.7 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120229220809.GC20565@ubuntu-macmini>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <CACxGe6sAcubJvc6LaVRxt+XzBz0jKpxSAPLdOvXkQz=NkXG5vQ@mail.gmail.com>
 <20120229175327.GA20565@ubuntu-macmini> <CACxGe6uc+LZjuMLS5DZELzAsHsnhObL6mdPzdMnNVbfriTfNwg@mail.gmail.com>
 <20120229195042.GB20565@ubuntu-macmini> <CACxGe6tK85FgYAT-1JQbLxEhRS34v2MPsx8urXADi6v2FnQ2gw@mail.gmail.com>
 <20120229220809.GC20565@ubuntu-macmini>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Feb 2012 16:32:28 -0600
X-Google-Sender-Auth: 2rGiOafrdp1KufxgNw1rG6gEe6c
Message-ID: <CACxGe6tLCYhuiAH1Q1PoWTzFLmZ0watw==0g76J1hS-Qurzyrw@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
To: Grant Likely <grant.likely@secretlab.ca>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 4:08 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Feb 29, 2012 at 03:23:20PM -0600, Grant Likely wrote:
>> On Wed, Feb 29, 2012 at 1:50 PM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > On Wed, Feb 29, 2012 at 12:43:23PM -0600, Grant Likely wrote:
>> >> On Wed, Feb 29, 2012 at 11:53 AM, Seth Forshee
>> >> <seth.forshee@canonical.com> wrote:
>> >> > On Wed, Feb 29, 2012 at 11:46:39AM -0600, Grant Likely wrote:
>> >> >> On Wed, Feb 22, 2012 at 8:37 AM, Seth Forshee
>> >> >> <seth.forshee@canonical.com> wrote:
>> >> >> > Apple laptops with hybrid graphics have a device named gmux that
>> >> >> > controls the muxing of the LVDS panel between the GPUs as well as screen
>> >> >> > brightness. This driver adds support for the gmux device. Only backlight
>> >> >> > control is supported initially.
>> >> >> >
>> >> >> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> >> >>
>> >> >> Works for me.
>> >> >>
>> >> >> Tested-by: Grant Likely <grant.likely@secretlab.ca>
>> >> >>
>> >> >> Now I just need to figure out how to get the desktop backlight widget
>> >> >> to use gmux_backlight instead of acpi_video0...
>> >> >
>> >> > The easy way is to pass acpi_backlight=vendor to the kernel, then you
>> >> > won't have acpi_vidoe0.
>> >>
>> >> That did it, thanks.  I'm assume something is in the works to set it
>> >> up automatically?
>> >
>> > Not that I'm aware of. A number machines have this problem, that the
>> > standard ACPI backlight interfaces are implemented but don't work. This
>> > generally isn't detectable in software; with the Apples at least
>> > everything looks like it's working except that the brightness doesn't
>> > change (but not all Apple laptops are affected, so qurking based on
>> > manufacturer wouldn't work). All we're left with is DMI quirking, which
>> > isn't practical. Maybe we could add something so a platform driver can
>> > tell acpi_video that it knows the ACPI backlight doesn't work, but I
>> > think on some platforms that still is going to be based off of DMI
>> > information.
>>
>> blacklisting based on specific product name (ie. MacBookPro8,*) or
>> machine model is probably the best.  It wouldn't be the first
>> blacklist in the linux kernel.
>
> I think the blacklist would have to be against specific product names.
> For example, the MacBook Pro 8,1 has a working acpi_video backlight and
> no gmux_backlight, the 8,2 has both but only gmux_backlight works, and I
> suspect the 8,3 is the same as the 8,2.

I have the 8,3, and my testing confirms that.

> We'd probably end up with an
> entry in the blacklist for every single model whose acpi_video backlight
> doesn't work, adding entries for each new generation of MacBooks.
>
> And if we start blacklisting Macs we'd have start doing it for other
> machines too, I guess. From what I've seen, open-ended blacklists like
> this get nacked pretty consistently nowadays.

An alternative would be to blacklist or disable acpi0_backlight when
the apple-gmux driver loads.  I don't know how acceptable that is, but
I also don't have much sympathy for nacking blacklists if there isn't
a viable alternative.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
