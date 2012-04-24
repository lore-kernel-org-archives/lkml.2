Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2DXXPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:15:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43259 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DXXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:15:49 -0400
Date: Tue, 24 Apr 2012 16:15:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: push the tty_lock down into the map handling
Message-ID: <20120424231546.GA29153@kroah.com>
References: <20120424100605.1409.32356.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424100605.1409.32356.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:06:06AM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> When we do this it becomes clear the lock we should be holding is the vc
> lock, and in fact many of our other helpers are properly invoked this way.
> 
> We don't at this point guarantee not to race the keyboard code but the results
> of that appear harmless and that was true before we started as well.
> 
> We now have no users of tty_lock in the console driver...

Yeah!!!

Nice job, thanks for unwinding all of this mess, it's looking much
better.

greg k-h
