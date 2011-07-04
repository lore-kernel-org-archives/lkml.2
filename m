Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1GDPmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:42:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab1GDPlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:41:06 -0400
Date: Mon, 4 Jul 2011 08:32:24 -0700
From: Greg KH <gregkh@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] debugfs: add debugfs_create_int
Message-ID: <20110704153224.GA17358@suse.de>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
 <1309702581-16863-3-git-send-email-akinobu.mita@gmail.com>
 <20110703162329.GA28131@suse.de>
 <CAC5umyh_25z9LV=T86807ey8yZRGwmhsPG44OqZdtcR-3wzb4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyh_25z9LV=T86807ey8yZRGwmhsPG44OqZdtcR-3wzb4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 02:31:25PM +0900, Akinobu Mita wrote:
> 2011/7/4 Greg KH <gregkh@suse.de>:
> > On Sun, Jul 03, 2011 at 11:16:16PM +0900, Akinobu Mita wrote:
> >> Introduce debugfs_create_int() for creating a debugfs file that is used to
> >> read and write an int value.
> >
> > Um, what's wrong with the existing s32 and s64 versions that debugfs
> > already provides?
> 
> I couldn't find s32 version in linux/debugfs.h
> 
> > userspace doesn't know what "int" means for the kernel as it might be
> > running in 32bit mode with a 64bit kernel.  That is why this isn't a
> > good idea, so please convert your other patch to use the existing api
> > and change the variable type in your patch.
> 
> Shoud I add debugfs_create_s32() instead of debugfs_create_int() for
> this?

Does it have to be a signed value?  If not, just use the
debugfs_create_u32() function.  Or use that and just cast the result,
right?

thanks,

greg k-h
