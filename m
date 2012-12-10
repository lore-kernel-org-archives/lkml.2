Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab2LJUeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:34:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43536 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LJUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:34:10 -0500
Date: Mon, 10 Dec 2012 12:34:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable 1/1] freezer: PF_FREEZER_NOSIG should be cleared
 along with PF_NOFREEZE
Message-ID: <20121210203406.GB21258@kroah.com>
References: <50BF9CC2.7070705@canonical.com>
 <1354762294.17107.157.camel@deadeye.wl.decadent.org.uk>
 <20121206124201.GA30705@redhat.com>
 <50C10391.4040903@canonical.com>
 <20121207144901.GA6478@redhat.com>
 <20121207144922.GB6478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207144922.GB6478@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 03:49:22PM +0100, Oleg Nesterov wrote:
> This patch is only for pre-v3.3 stable trees which backported
> b40a7959 "freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD".
> v3.3+ doesn't need this fix.
> 
> b40a7959 is the trivial bugfix, but unfortunately I forgot that
> until 34b087e4 "freezer: kill unused set_freezable_with_signal()"
> there were another only-for-kernel-threads flag, PF_FREEZER_NOSIG,
> which should be cleared as well.
> 
> See https://bugs.launchpad.net/ubuntu/+source/v86d/+bug/1080530
> The freezer fails because it expects that a PF_FREEZER_NOSIG task
> doesn't need a signal. Before b40a7959 it wrongly succeeds leaving
> the PF_NOFREEZE | PF_FREEZER_NOSIG task unfrozen.
> 
> Reported-and-tested-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Cc: stable@vger.kernel.org # pre v3.3 if commit b40a7959 was taken

>From what I can tell, 3.0-stable didn't take this patch, so it should be
fine.  Ben, I don't know about 3.2, you should check this.

Oleg, thanks for doing this work, much appreciated.

greg k-h
