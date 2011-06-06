Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1FFV4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:56:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:59404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044Ab1FFV4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:56:17 -0400
Date: Mon, 6 Jun 2011 14:55:49 -0700
From: Greg KH <gregkh@suse.de>
To: anish <anish198519851985@gmail.com>
Cc: jic23@cam.ac.uk, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
Message-ID: <20110606215549.GA7543@suse.de>
References: <1307387257.4327.12.camel@anish-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307387257.4327.12.camel@anish-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:37:37AM +0530, anish wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> Replace kmalloc with local variables as it was un-necessary and
> also removed the redudant code after this change.

No, it was necessary, you just broke this driver on ARM-based systems,
which isn't nice at all :(

SPI data, like USB data, has to come from kmalloced data, not from the
stack, or bad things can, and will, happen.

So I can't accept this patch, sorry.

greg k-h
