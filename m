Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1FOXU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 19:20:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1FOXU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 19:20:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Date: Thu, 16 Jun 2011 01:21:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
References: <20110608074523.211912903@de.ibm.com> <201106142250.15041.rjw@sisk.pl> <20110615093629.07f01779@mschwide>
In-Reply-To: <20110615093629.07f01779@mschwide>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106160121.26767.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 15, 2011, Martin Schwidefsky wrote:
> On Tue, 14 Jun 2011 22:50:14 +0200
...
> > Well, I'm sure we can handle that. :-)
> > 
> > I thought of the following approach:
> > 
> > * Allocate memory for saving the relevant bits of the storage keys before
> >   the memory preallocation kicks in.
> > 
> > * Save the storage key bits to that memory before creating the image (be
> >   careful about the storage keys of the pages they are being stored into).
> > 
> > * After getting control from the boot kernel, restore the storage key bits
> >   saved before creating the image.
> > 
> > * Free additional memory used for storing them.
> > 
> > This way we wouldn't have to worry about any interactions with
> > snapshot_read_next / snapshot_write_next etc.
> 
> Well before the preallocation kicked in we don't know which are the relevant
> storage keys. The only other option would be to store all of them which I
> consider to be a inferior solution. 

OK, I see your point.  You think it's necessary to save the entire storage key
for each page and you'd like to save storage keys only for those pages, whose
contents is going to be saved in the image.

Now, I need to look at your original patch again. :-)
