Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882Ab2FEJTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:19:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61177 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2FEJTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:19:04 -0400
Date: Tue, 5 Jun 2012 18:18:58 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120605091858.GA20917@kroah.com>
References: <1338886747-28088-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338886747-28088-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 04:59:07PM +0800, Ming Lei wrote:
> Firstly, .shutdown callback may touch a uninitialized hardware
> if dev->driver is set and .probe is not completed.

When would that ever happen?

> Secondly, device_shutdown() may dereference a null pointer to cause
> oops when dev->driver is cleared after it is checked in device_shutdown().

Again, when would that happen?  A new device/driver being added to the
system as it is being shutdown?

Has anyone ever hit that before?

Is this really needed?

greg k-h
