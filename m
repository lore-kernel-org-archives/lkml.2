Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1CQUPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:15:48 -0400
Received: from kroah.org ([198.145.64.141]:52623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab1CQUPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:15:45 -0400
Date: Thu, 17 Mar 2011 13:15:34 -0700
From: Greg KH <greg@kroah.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
Message-ID: <20110317201534.GA2921@kroah.com>
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
 <20110317193023.GA16790@kroah.com>
 <4D826718.3030001@redhat.com>
 <4D826A4F.9070608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D826A4F.9070608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 04:08:47PM -0400, Prarit Bhargava wrote:
> >>   
> >>     
> >>> +}
> >>> +
> >>> +/* add additional sysfs files here */
> >>> +static struct device_attribute smbios_attrs[] = {
> >>> +	__ATTR_RO(version),
> >>> +};
> >>>     
> >>>       
> >> So a whole new class just for a single version file in sysfs?
> >>
> >>     
> 
> Right now it is only the version file.  Eventually I was thinking that
> this would grow to include sysfs entries for the BIOS info (date,
> vendor, etc.) and Product and Chassis info, not to mention all the
> various SMBIOS structs.  We have at least one driver that goes through a
> lot of trouble to get this info, and IIRC, the PCI code now outputs
> type41 and type9 fields for the network device naming stuff.
> 
> I thought that meant it needed a new class but, as you pointed out, that
> isn't the case.  I'll ping kernel-mentors and see if anyone there might
> point me to the right class for this data.

See my other response for how to go about this.

> >> I'm confused, what exactly are you trying to show here that you can't
> >> show in the existing device/class structure?
> >>
> >>     
> 
> I want to show the version of the SMBIOS on the system.  But it doesn't
> seem to make sense to me to expose it in the DMI sysfs code.  The SMBIOS
> provides the DMI code, not the other way around.  We've become used to
> the DMI code, and we're adding SMBIOS decoding to it but the other parts
> of the kernel are doing their own decoding of the SMBIOS to get
> additional info.  To me, at least, this means we should have a central
> place for it.

Ok, that's fine.  But you can't remove the existing DMI files and
symlinks, so how are you anticipating handling all of that?

This seems like a lot of work at the moment just for a version file,
let's see some more use of this which would justify it being added to
the kernel first.

thanks,

greg k-h
