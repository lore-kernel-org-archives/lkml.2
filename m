Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1AFXg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:36:26 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:33865
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540Ab1AFXgY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:36:24 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: romieu@fr.zoreil.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110106.142906.226774601.davem@davemloft.net>
References: <20110106204240.GA6361@electric-eye.fr.zoreil.com>
	 <1294347036.24378.13.camel@lithium> <1294352651.24378.17.camel@lithium>
	 <20110106.142906.226774601.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Thu, 06 Jan 2011 23:34:28 +0000
Message-ID: <1294356868.24378.26.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d2651f7.7721-fd7-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 14:29 -0800, David Miller wrote:
> You have to initialize par->state.vgabase in the s3fb driver to the
> VGA area iomem pointer you calculated at boot time.

I just had a look through the svgalib.c. It makes a lot of calls to
vgastate with the NULL parameter for the vga iobase, I guess that's
definitely why it's crashing the driver. 

Also, svga.h has inline functions that needs modifying. Looks like a big
change to let it work with the vga iobase or NULL. Perhaps just passing
the par->state.vgabase into those functions could make it work. Usually
this gets initialised as zero at boot or driver load so the default
could be NULL anyway for those drivers that assume it is located at 0. 
-- 
Tactical Nuclear Kittens
