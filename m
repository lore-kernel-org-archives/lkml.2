Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab1GDIJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:09:50 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:53838 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1GDIJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:09:48 -0400
Date: Mon, 4 Jul 2011 10:09:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110704100929.68674ea3@mschwide>
In-Reply-To: <20110703174616.GB26790@elf.ucw.cz>
References: <20110608074523.211912903@de.ibm.com>
	<201106121441.35059.rjw@sisk.pl>
	<20110614105001.2f991377@mschwide>
	<201106142250.15041.rjw@sisk.pl>
	<20110615093629.07f01779@mschwide>
	<20110703174616.GB26790@elf.ucw.cz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011 19:46:16 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > I think, however, that we really should try to merge them.  The only
> > > difference seems to be how the additionally allocated pages will be populated
> > > and what's going to happen to their contents during restore.
> > > 
> > > ACPI will simply copy the NVS memory to those pages, while S390 will save
> > > the relevant storage key bits in there.
> > 
> > One complication to keep in mind is that we need to know which storage key
> > goes to which page frame. We need something like the orig_bm/copy_bm or
> > we'd have to store the pfn with the key. Simply storing the key for every
> > page will make the array unnecessarily big.
> 
> How big is the overhead? In percent / in megabytes?

Well, that depends on the ratio of the size of the hibernation image and
the total size of the ram. Consider a 1TB machine with a hibernation image
size of lets say 128 GB. The hibernation image would require 32 MB worth
of storage keys (0.024%), for 1TB the array size would be 256 MB (0.19%).

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

