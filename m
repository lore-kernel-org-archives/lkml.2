Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1H3KcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:32:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43221 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1H3KcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:32:11 -0400
Date: Tue, 30 Aug 2011 13:29:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling in
 vmbus_bus_init()
Message-ID: <20110830102949.GD3705@shale.localdomain>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-41-git-send-email-kys@microsoft.com>
 <20110829180842.GA23618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829180842.GA23618@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> err3:
> 	free_irq(irq, hv_acpi_dev);
> err2:
> 	bus_unregister(&hv_bus);
> err1:
> 	hv_cleanup();

Also here is an oldbie trick.  You could use multiples of ten like
err30, err20, and err10.  That way if you can add more error handling
in the middle without changing the numbering.  I knew my GW-BASIC
experience would come in handy one day.  :)

The better way to label things is based on what happens when you get
there: err_irq, err_unregister, err_cleanup.

Some people label things based on where the goto is, but that breaks
down if there is more than one goto.  It doesn't really make sense to
name the destination after the starting point.

regards,
dan carpenter
