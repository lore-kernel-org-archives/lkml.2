Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1HEH4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:56:12 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45050 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1HEH4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:56:10 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: USB mini-summit at LinuxCon Vancouveroliver
Date: Fri, 5 Aug 2011 09:59:00 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
References: <20110610002103.GA7169@xanatos> <20110804225603.GA2557@kroah.com> <4E3B9FB4.30709@redhat.com>
In-Reply-To: <4E3B9FB4.30709@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108050959.00873.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. August 2011, 09:45:56 schrieb Hans de Goede:
> This is the issue on which I feel a bit stonewalled. Simple putting your
> fingers in your ears and singing la la la do it in userspace is not going
> to cut it here. There is no way to do this race free in userspace, unless
> all possible callers of mount get modified. Moreover 99% of the necessary
> accounting for this is already done in the kernel. We already have the notion
> of a block device being in use. We simply need to add some code to pass
> this notion to the usb mass storage driver, and add a new try_disconnect
> callback for usb drivers. I'm not saying this is going to be completely
> straight forward, but it ain't rocket science either. And it so very
> obviously is the right thing to do, that I'm getting very tired of
> the do it in userspace song I keep hearing.

Doing a try_disconnect() would also solve the dual camera issue.
But it doesn't really interfere with the user space vs. kernel space
issue. You simply have to expand the ioctl interface to have
an ioctl that triggers this API call in the kernel.

A V4L2 device would return an error if its device node is opened,
otherwise disconnect.

	Regards
		Oliver

		
