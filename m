Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2GIWD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:03:58 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:8418 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2GIWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:03:57 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=Z3SxTXhDxwB9DgFz2GvsKTXM8eiRnEnEBiVCAN+/Iln/YFiqhj3WEzTr9Rpl
	u2bHgsN0wxv38aqACqBQhl5fUPesFsFqqtfTxeMWG0VoBVmi6sQSNeThy
	n9KLAXoihHq8y8om5UeBHdqgTARsQDZcZ9J5kuQtvCxP6x+QClqLWk=;
X-Spam-Processed: mail.digidescorp.com, Mon, 09 Jul 2012 17:03:55 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.36.221
X-Return-Path: prvs=1537d3712a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341871431.1944.4.camel@iscandar>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 17:03:51 -0500
In-Reply-To: <877gucobya.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <1341606824.2214.14.camel@iscandar.digidescorp.com>
	 <871ukobntl.fsf@devron.myhome.or.jp> <1341623782.2021.9.camel@iscandar>
	 <87wr2g9kh3.fsf@devron.myhome.or.jp> <1341679286.2435.12.camel@iscandar>
	 <87zk7bo6aq.fsf@devron.myhome.or.jp>
	 <1341835422.2215.6.camel@iscandar.digidescorp.com>
	 <87sjd1nj7s.fsf@devron.myhome.or.jp>
	 <1341845277.2215.10.camel@iscandar.digidescorp.com>
	 <87obnooqz7.fsf@devron.myhome.or.jp>
	 <1341851223.2215.22.camel@iscandar.digidescorp.com>
	 <1341853758.2215.34.camel@iscandar.digidescorp.com>
	 <87bojooinr.fsf@devron.myhome.or.jp>
	 <1341865572.31078.2.camel@iscandar.digidescorp.com>
	 <877gucobya.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 06:34 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> >> Ah, i_ino. I was talking about i_pos. Well, so, what happens if the
> >> child was renamed to other parent on NFS server machine (not via nfs
> >> client)? The file handle would be including the old i_ino, and the old
> >> i_ino on file handle is still vaild as old parent. So, it returns the
> >> wrong parent?
> >
> > Yes, but I believe exportfs_decode_fh() handles that case:
> >
> >   /*
> >    * Now that we've got both a well-connected parent and a
> >    * dentry for the inode we're after, make sure that our
> >    * inode is actually connected to the parent.
> >    */
> >
> >
> > Really, the FAT NFS code will pretty much parallel that of ext2.
> 
> Hm, not really, if the file handle is including parent ino. ext2 will
> get the latest parent ino, because it checks parent of inode of file
> handle.

Can you point me to the code for this? The code I see looks pretty
congruent to what I think the FAT code would be.

> But if the file handle is including parent ino and we believe it is
> parent, I think NFS server can be return the old parent. The difference
> is the result of ->get_parent().

I'm a little confused about which function we're discussing here.
fat_get_parent() isn't called with a file handle. fat_fh_to_parent() is,
but it is only called by exportfs_decode_fh() and I am reasonably sure
that that function is handling the case you're concerned about.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>



