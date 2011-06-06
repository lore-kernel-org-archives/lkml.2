Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab1FFWLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:11:00 -0400
Received: from mail.perches.com ([173.55.12.10]:2549 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1FFWK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:10:59 -0400
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: anish <anish198519851985@gmail.com>, devel@driverdev.osuosl.org,
        arnd@arndb.de, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        manuel.stahl@iis.fraunhofer.de
In-Reply-To: <20110606215549.GA7543@suse.de>
References: <1307387257.4327.12.camel@anish-desktop>
	 <20110606215549.GA7543@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 15:10:57 -0700
Message-ID: <1307398257.4994.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 14:55 -0700, Greg KH wrote:
> On Tue, Jun 07, 2011 at 12:37:37AM +0530, anish wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > Replace kmalloc with local variables as it was un-necessary and
> > also removed the redudant code after this change.
> SPI data, like USB data, has to come from kmalloced data, not from the
> stack, or bad things can, and will, happen.

Perhaps just add a comment like:

+       u8 *tx = kmalloc(2, GFP_KERNEL);	/* can't be on stack */

It might be better to do a single kmalloc(4)
than 2 separate kmalloc(2)'s.


