Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2GEVks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:40:48 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50082 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754906Ab2GEVkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:40:46 -0400
Date: Thu, 5 Jul 2012 17:40:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Wilcox <matthew@wil.cx>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
In-Reply-To: <20120703203512.GE28804@parisc-linux.org>
Message-ID: <Pine.LNX.4.44L0.1207051736550.13212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Matthew Wilcox wrote:

> I think the necessary algorithm is simpler than that:
> 
> Send RC10 (unless the device supports PI, in which case it's probably
> 	enterprisey and well-tested)
> Send RC16
> If RC10 capacity agrees with RC16 capacity, use extra RC16 data.
> (for values of "agrees with" that include the "-1 to use RC16" indicator)
> 
> Sure, it's one extra command, but really, who cares?

Well, some USB devices might care.  Right now we don't send RC16 to 
them at all because they get RC10 first and it indicates a capacity 
below 2 TB.

In the end, usb-storage may be forced to use the NO_READ_CAPACITY_16 
flag with all devices except those we can positively identify as a 
USB-(S)ATA bridge.

Alan Stern

