Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab0EMWzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:55:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576Ab0EMWzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:55:45 -0400
Date: Thu, 13 May 2010 15:54:15 -0700
From: Greg KH <gregkh@suse.de>
To: Joey Lee <jlee@novell.com>
Cc: dmitry.torokhov@gmail.com, mzxreary@0pointer.de, greg@kroah.com,
       rpurdie@linux.intel.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state with
 BIOS when function key pressed
Message-ID: <20100513225415.GA23450@suse.de>
References: <4BEC74C002000023000190EE@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BEC74C002000023000190EE@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 05:53:04AM -0600, Joey Lee wrote:
> Hi Dmitry, 
> 
> Thank's for your review.
> 
> 於 四，2010-05-13 於 00:52 -0700，Dmitry Torokhov 提到：
> > On Wed, May 12, 2010 at 11:56:47AM -0700, Greg KH wrote:
> > >  static int __init msi_init(void)
> > > @@ -819,6 +875,7 @@ static void __exit msi_cleanup(void)
> > >  	platform_driver_unregister(&msipf_driver);
> > >  	backlight_device_unregister(msibl_device);
> > >  
> > > +	i8042_remove_filter(msi_laptop_i8042_filter);
> > 
> > You also need cancel_delayed_work_sync() here. Sorry for not noticing
> > this before.
> > 
> 
> Yes, you are right, need add cancel_delayed_work_sync().

Want to make up an additional patch to add on top of this that does it?

thanks,

greg k-h
