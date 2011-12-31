Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1LaAk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 19:40:29 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56871 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1LaAk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 19:40:26 -0500
Date: Sat, 31 Dec 2011 00:40:16 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20111231004015.GA23226@srcf.ucam.org>
References: <20111230235421.GA6054@redhat.com>
 <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 04:22:06PM -0800, Linus Torvalds wrote:

> It's isight_firmware_load(), in the isight_firmware driver. The driver
> doesn't actually do anything but load the firmware, and is apparently
> not very good at that either.
> 
> It should either fake a disconnect and reconnect of the device (and
> let the reconnect then load the firmware through udev or something) or
> it should just save the firmware image in memory from the original
> load, and make the resume just re-initialize it - not load it.

Mm. My recollection is that these devices retained their firmware over 
suspend/resume, so wouldn't resume with a USB id that matched the driver 
and so this code shouldn't be called. It seems that either I was 
horribly wrong about that, or something's changed in the USB layer 
that's resulting in them resetting themselves. Newer devices don't 
require this, so I'll need to try to chase up some older hardware to 
figure out what's going on.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
