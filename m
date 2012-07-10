Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2GJIyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:54:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8950 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2GJIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:54:52 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Joel Becker'" <jlbec@evilplan.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
In-reply-to: <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
Subject: RE: [RFC 0/2] USB gadget - configfs
Date: Tue, 10 Jul 2012 10:54:44 +0200
Message-id: <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1YMlysoN6nT8h7S8SdYONJA9extQGP3d+Q
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joel,

Thank you for your review.

@Sebastian, Alan, Felipe: Thank you, too.

On Monday, July 02, 2012 11:09 AM Joel Becker wrote:

<snip>

> 
> > As a prerequisite it adds an operation to configfs. The operation allows
> > checking if it is ok to remove a pseudo directory corresponding to a
> > configfs item/group.
> 
> 	I NAK'd that patch because you should be using
> configfs_depend_item().  If you have trouble with that, let's talk.
> 

Now I see the configfs_depend_item() is the way to go. I am in doubt,
though, so could you please throw some light on it? Here is why:
As an example I did a quick-and-dirty port of f_mass_storage to the new,
configfs-based approach. The business logic of this function is that
once a lun is opened, it must not be changed (deleted, in particular)
until it is closed. The moment the lun is opened is defined by a write
to a configfs "file" attribute of a lun config item:

               +-/lunX
               |  |
               |  +-file
               |  |
               |  +-nofua
               |  |
               |  +-removable
               |  |
               |  +-ro

So, the config item corresponding to the lun becomes depended on during
the write file operation, the same with undepend. Can this be expressed
with configfs_depend/undepend_item()? Your code in fs/configfs/dir.c
contains a warning not to call the configfs_depend_item()
from a configfs callback.
In this case, is store_attribute a configfs callback?

Thanks,

Andrzej



