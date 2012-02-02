Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab2BBTy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:54:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2BBTy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:54:58 -0500
Date: Thu, 2 Feb 2012 11:54:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-kernel@vger.kernel.org, lars@metafoo.de, rpurdie@rpsys.net
Subject: Re: [PATCH v2] add LED driver for PCA9663 I2C chip
Message-Id: <20120202115456.7fe11c18.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.01.1202021130070.10172@pmeerw.net>
References: <1326916289-19004-1-git-send-email-pmeerw@pmeerw.net>
	<20120130162849.635c83a9.akpm@linux-foundation.org>
	<20120130163424.ef8eb9af.akpm@linux-foundation.org>
	<alpine.DEB.2.01.1202021130070.10172@pmeerw.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012 11:42:09 +0100 (CET)
Peter Meerwald <pmeerw@pmeerw.net> wrote:

> 
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > +exit:
> > > > +	while (i--) {
> > > > +		led_classdev_unregister(&pca9633[i].led_cdev);
> > > > +		cancel_work_sync(&pca9633[i].work);
> > > > +	}
> > > This (untested!) loop has an off-by-one error. 
> 
> > Well, it's partly wrong.  It's wrong for the cancel_work_sync() but not
> > for the led_classdev_unregister().  The cancel_work_sync() can just be
> > removed: we haven't scheduled any works yet.
> 
> there are 4 leds with get led_classdev_register()ed
> 
> wouldn't it be possible that someone is starting to use led1 while led3 has 
> not been registered yet? if registration for led3 fails, the exit code 
> (above) is called and there might be work scheduled
> 
> so (hypothetically):
> register led1 -> ok
> register led2 -> ok
> use led1 (schedule work)
> register led3 -> fail -> exit code
> 
> the code has been copied from other led drivers
> I think there is no harm to keep cancel_work_sync()

Spose so - it won't hurt.  And I was wrong about there being an
off-by-one.

