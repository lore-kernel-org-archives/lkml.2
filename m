Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2AYT4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:56:09 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:40878 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751318Ab2AYT4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:56:07 -0500
Date: Wed, 25 Jan 2012 20:33:46 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-input@vger.kernel.org,
        linux-pcmcia@lists.infradead.org, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/5] Dynamic ID addition doesn't need get_driver()
Message-ID: <20120125193346.GB9192@comet.dominikbrodowski.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Greg KH <greg@kroah.com>, linux-input@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, Jiri Kosina <jkosina@suse.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
References: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:34:41PM -0500, Alan Stern wrote:
> As part of the removal of get_driver()/put_driver(), this patch
> (as1511) changes all the places that add dynamic IDs for drivers.
> Since these additions are done by writing to the drivers' sysfs
> attribute files, and the attributes are removed when the drivers are
> unregistered, there is no reason to take an extra reference to the
> drivers.
> 
> The one exception is the pci-stub driver, which calls pci_add_dynid()
> as part of its registration.  But again, there's no reason to take an
> extra reference here, because the driver can't be unloaded while it is
> being registered.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: Dominik Brodowski <linux@dominikbrodowski.net>

For the PCMCIA part: Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik
