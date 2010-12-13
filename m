Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0LMVxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:53:16 -0500
Received: from mail.perches.com ([173.55.12.10]:2586 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0LMVxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:53:15 -0500
Subject: Re: [PATCH v2] Staging: rt2860: include KERN_* in printk
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>,
        "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20101213211531.GA19783@kroah.com>
References: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
	 <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
	 <20101213183032.GA6147@kroah.com>
	 <20101213202429.GA6811@bart.evergreen.loc>
	 <20101213211531.GA19783@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 13:53:12 -0800
Message-ID: <1292277192.26970.65.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 13:15 -0800, Greg KH wrote:
> On Mon, Dec 13, 2010 at 09:24:30PM +0100, L. Alberto Giménez wrote:
> > +#define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)
> > Recommended by Joe. I agree that it is cleaner and more compliant.
> Not really, it should be replaced with dev_err() or some such universal
> replacement.

It's used with and without access to a struct device.

The uses that have a struct device available should be
dev_<foo> and with a struct net_device should be netdev_<foo>
though that's a wider change.

It's also used in consecutive calls without newline where
KERN_CONT should be used instead.
 
Greg, you replied to the list but not the sender.
Please don't drop the sender.

