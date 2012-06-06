Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab2FFV0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:26:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49584 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2FFV0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:26:03 -0400
Date: Thu, 7 Jun 2012 06:25:54 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Remove 'registers' and 'flags' from sysfs
Message-ID: <20120606212554.GA17852@kroah.com>
References: <4FCD0FC7.9010105@micron.com>
 <20120605093314.GC21560@kroah.com>
 <4FCE4D67.1030309@micron.com>
 <20120605202555.GA4727@kroah.com>
 <4FCF9BA1.90308@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCF9BA1.90308@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:04:17AM -0700, Asai Thambi S P wrote:
> On 6/5/2012 1:25 PM, Greg KH wrote:
> 
> > On Tue, Jun 05, 2012 at 11:18:15AM -0700, Asai Thambi S P wrote:
> >> On 6/5/2012 2:33 AM, Greg KH wrote:
> >>
> >>> On Mon, Jun 04, 2012 at 12:43:03PM -0700, Asai Thambi S P wrote:
> >>>>
> >>>> This patch removes entries 'registers' and 'flags' from sysfs. Updated ABI file
> >>>> to reflect this change.
> >>>>
> >>>> Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
> >>>
> >>> Much nicer, thanks for doing this:
> >>>
> >>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>
> >>> But, one question on a different sysfs file:
> >>>
> >>>>  What:           /sys/block/rssd*/status
> >>>>  Date:           April 2012
> >>>>  KernelVersion:  3.4
> >>>>  Contact:        Asai Thambi S P <asamymuthupa@micron.com>
> >>>>  Description:    This is a read-only file. Indicates the status of the device.
> >>>
> >>> What "status" is this showing?  Why is this a sysfs file?  Who
> >>> needs/wants it?
> >>
> >>
> >> This shows the device status - online, write_protect or thermal_shutdown. This
> >> would be used by management application.
> > 
> > Is it used by a management application?  Shouldn't such a tool use the
> > "standard" block device status files instead?  I thought we exported
> > that information already in the /sys/block/* files.
> > 
> 
> 
> device status is not exported by standard block interface.

Ok, but don't you think it should be?  Why make this unique to only your
driver?

greg k-h
