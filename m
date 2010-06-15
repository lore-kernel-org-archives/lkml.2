Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab0FOSlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:41:49 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:57160 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab0FOSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:41:42 -0400
Subject: Re: [PATCH] uniform cdrom: fix mutex unlocking in
 /proc/sys/dev/cdrom/info file
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
In-Reply-To: <20100614123417.444a82c3.akpm@linux-foundation.org>
References: <1276102610.5572.32.camel@cowboy>
	 <20100614123417.444a82c3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 14:40:54 -0400
Message-ID: <1276627254.4666.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 12:34 -0700, Andrew Morton wrote:
> On Wed, 09 Jun 2010 12:56:50 -0400
> Davidlohr Bueso <dave.bueso@gmail.com> wrote:
> 
> > If the last if condition passes the cdrom_mutex mutex will not be unlocked. 
> > This patch fixes this and also removes the unnecessary doit label that was only invoked by the done label.
> > 
> 
> Confused.  There is no way in which cdrom_sysctl_info() can forget to
> unlock cdrom_mutex.
> 

Ok, I had misread the code then, one of the reasons I don't like goto
labels, but that's a different story.

Regarding cdrom_sysctl_info(), I have noticed in several netbooks
(haven't
looked in other machines with no cdrom drive) that the
/proc/sys/dev/cdrom/info file shows no values for the listed entries,
ie:

CD-ROM information, Id: cdrom.c 3.20 2003/12/17

drive name:
drive speed:
drive # of slots:
Can close tray:
Can open tray:
...

Now, is this expected behavior? If not, should it be changed to
something
more descriptive? Perhaps it would affect user space applications that
read
the file?

Thanks,
Davidlohr

