Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2JOQtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:49:05 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63413 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2JOQtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:49:02 -0400
Date: Mon, 15 Oct 2012 09:48:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during
 bus reset if storage interface exits
Message-ID: <20121015164850.GB6458@kroah.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
 <1350278059-14904-4-git-send-email-ming.lei@canonical.com>
 <2564763.3cNFlv543H@linux-lqwf.site>
 <CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 08:06:36PM +0800, Ming Lei wrote:
> On Mon, Oct 15, 2012 at 5:34 PM, Oliver Neukum <oneukum@suse.de> wrote:
> >
> > I think limiting this to devices which have a storage device is not
> > productive. What if you are using iSCSI or nbd? In the long run
> 
> You mean other non-mass storage or non-uas usb interfaces may
> be involved in iSCSI or nbd? If not, the patch should be OK.
> If yes, could you list them?

Networking over USB to serial devices (sadly, it does happen, and some
network devices actually show up this way.)

In other words, don't put policy like this in the USB core for no good
reason.

greg k-h
