Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2B2WIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:08:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2B2WIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:08:13 -0500
Date: Wed, 29 Feb 2012 16:08:09 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120229220809.GC20565@ubuntu-macmini>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <CACxGe6sAcubJvc6LaVRxt+XzBz0jKpxSAPLdOvXkQz=NkXG5vQ@mail.gmail.com>
 <20120229175327.GA20565@ubuntu-macmini>
 <CACxGe6uc+LZjuMLS5DZELzAsHsnhObL6mdPzdMnNVbfriTfNwg@mail.gmail.com>
 <20120229195042.GB20565@ubuntu-macmini>
 <CACxGe6tK85FgYAT-1JQbLxEhRS34v2MPsx8urXADi6v2FnQ2gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6tK85FgYAT-1JQbLxEhRS34v2MPsx8urXADi6v2FnQ2gw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 03:23:20PM -0600, Grant Likely wrote:
> On Wed, Feb 29, 2012 at 1:50 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Wed, Feb 29, 2012 at 12:43:23PM -0600, Grant Likely wrote:
> >> On Wed, Feb 29, 2012 at 11:53 AM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > On Wed, Feb 29, 2012 at 11:46:39AM -0600, Grant Likely wrote:
> >> >> On Wed, Feb 22, 2012 at 8:37 AM, Seth Forshee
> >> >> <seth.forshee@canonical.com> wrote:
> >> >> > Apple laptops with hybrid graphics have a device named gmux that
> >> >> > controls the muxing of the LVDS panel between the GPUs as well as screen
> >> >> > brightness. This driver adds support for the gmux device. Only backlight
> >> >> > control is supported initially.
> >> >> >
> >> >> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >> >>
> >> >> Works for me.
> >> >>
> >> >> Tested-by: Grant Likely <grant.likely@secretlab.ca>
> >> >>
> >> >> Now I just need to figure out how to get the desktop backlight widget
> >> >> to use gmux_backlight instead of acpi_video0...
> >> >
> >> > The easy way is to pass acpi_backlight=vendor to the kernel, then you
> >> > won't have acpi_vidoe0.
> >>
> >> That did it, thanks.  I'm assume something is in the works to set it
> >> up automatically?
> >
> > Not that I'm aware of. A number machines have this problem, that the
> > standard ACPI backlight interfaces are implemented but don't work. This
> > generally isn't detectable in software; with the Apples at least
> > everything looks like it's working except that the brightness doesn't
> > change (but not all Apple laptops are affected, so qurking based on
> > manufacturer wouldn't work). All we're left with is DMI quirking, which
> > isn't practical. Maybe we could add something so a platform driver can
> > tell acpi_video that it knows the ACPI backlight doesn't work, but I
> > think on some platforms that still is going to be based off of DMI
> > information.
> 
> blacklisting based on specific product name (ie. MacBookPro8,*) or
> machine model is probably the best.  It wouldn't be the first
> blacklist in the linux kernel.

I think the blacklist would have to be against specific product names.
For example, the MacBook Pro 8,1 has a working acpi_video backlight and
no gmux_backlight, the 8,2 has both but only gmux_backlight works, and I
suspect the 8,3 is the same as the 8,2. We'd probably end up with an
entry in the blacklist for every single model whose acpi_video backlight
doesn't work, adding entries for each new generation of MacBooks.

And if we start blacklisting Macs we'd have start doing it for other
machines too, I guess. From what I've seen, open-ended blacklists like
this get nacked pretty consistently nowadays.

Seth

