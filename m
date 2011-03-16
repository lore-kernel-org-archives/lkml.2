Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab1CPFZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:25:22 -0400
Received: from ns2.allidaho.com ([66.232.90.194]:58019 "EHLO mail.allidaho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1CPFZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:25:18 -0400
X-Greylist: delayed 2495 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 01:25:18 EDT
From: "Dialup Jon Norstog" <thursday@allidaho.com>
To: Michael Cree <mcree@orcon.net.nz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        warns@pre-sense.de
Subject: Re: Alpha no longer recognises certain partition tables (v2.6.38)
Date: Tue, 15 Mar 2011 21:09:57 -0700
Message-Id: <20110316040630.M24051@allidaho.com>
In-Reply-To: <E0782A6F-B851-4A11-B740-446EF7941B7C@orcon.net.nz>
References: <4D7F2C11.907@orcon.net.nz> <AANLkTimRDH4S1QMN6f4AfKOe6ipPK6jm+g91nuBJYQJa@mail.gmail.com> <E0782A6F-B851-4A11-B740-446EF7941B7C@orcon.net.nz>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 67.206.183.147 (thursday)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To the lists:

Pardon me for a userland-type question, but is this going to be a problem if I
want to mount advfs disks? Or even some old OSF1 disks (that have some quite
valuable GIS covers on them)?  Just curious.

jn


On Wed, 16 Mar 2011 14:23:43 +1300, Michael Cree wrote
> On 16/03/2011, at 4:10 AM, Linus Torvalds wrote:
> > On Tue, Mar 15, 2011 at 2:06 AM, Michael Cree <mcree@orcon.net.nz>  
> > wrote:
> >> v2.6.38 boot reports it can't recognise the partition table on the  
> >> system
> >> disk on my Alpha and panics when it can't find the root device.
> >>
> >> It worked at v2.6.38-rc7.
> >>
> >> While I haven't done a bisect to fully verify I nevertheless  
> >> suggest the
> >> following patch as the likely cause:
> >>
> >> 1eafbfe Fix corrupted OSF partition table parsing
> >
> > That sounds likely. What does something like the attached do? In
> > particular, what's the printed-out value of the OSF npartitions thing?
> >
> > Also, it's quite possible that we should raise the value of
> > MAX_OSF_PARTITIONS. If I checked it right, the d_partitions[] array
> > starts at byte offset 148 in the sector, and it's 16 bytes in size, so
> > there _could_ be up to 22 partitions there. The fact that we had
> > defined the 'struct disklabel' to only contain 8 partitions is I think
> > from documentation, not a technical "there can be only eight".
> 
> I am not able to run the patch until much later today but I think 
> the  number of partitions is the issue.  I have three disks, all 
> with bsd  type partition tables, and the kernel sees the partition 
> tables of two  of them (they both have fewer than five partitions) 
> but the system  disk has about nine (or it might be ten) partitions. 
>  I didn't know  the limit when creating them some time ago and 
> assumed fdisk would  flag an error if the number of permitted 
> partitions was exceeded!   What's more it worked with recent kernels 
> until now.
> 
> I'll give the patch a whirl later (my) today.
> 
> Cheers
> Michael.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> alpha" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html


--
Open WebMail Project (http://openwebmail.org)

