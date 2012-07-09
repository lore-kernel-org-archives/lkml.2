Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2GIOsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:48:07 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:37952 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2GIOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:48:04 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=zJ8gXv+ovvdouSjVYJl9pbc5dEgC+j1UwKjmLLqLfd8ySgbHP+EBoZ8xcgKf
	9Fj0fcMz1Tm7zZyvzWOkPNVgPZ5GTNjqWQg+DOyDyd30Ezg+mrF3BC72f
	r3eT1i8VhcLgTnjug9JDOQneK/ufr29/McQBOcliUVC2oEeShSfEiU=;
X-Spam-Processed: mail.digidescorp.com, Mon, 09 Jul 2012 09:48:01 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1537d3712a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341845277.2215.10.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 09:47:57 -0500
In-Reply-To: <87sjd1nj7s.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <1341606824.2214.14.camel@iscandar.digidescorp.com>
	 <871ukobntl.fsf@devron.myhome.or.jp> <1341623782.2021.9.camel@iscandar>
	 <87wr2g9kh3.fsf@devron.myhome.or.jp> <1341679286.2435.12.camel@iscandar>
	 <87zk7bo6aq.fsf@devron.myhome.or.jp>
	 <1341835422.2215.6.camel@iscandar.digidescorp.com>
	 <87sjd1nj7s.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 22:43 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> >> We need the key, possible key is - if it is only directory, FAT may be
> >> able to use i_start as additional search key.
> >
> > Interesting idea. I think this, and reformulating the FAT NFS file
> > handle to include the parent's i_ino, will greatly simplify (and speed
> > up) the code.
> 
> Does it work even if the inode was rename()'ed?

AFAICT. I don't see why it wouldn't; on a rename, the inode's i_pos
changes but its i_ino stays the same, right?

Do you have any objection to making the use of a directory logstart
cache a mount option that defaults to off? It seems a shame to penalize
everyone - particularly embedded systems - with the overhead of such a
cache when FAT-backed-NFS seems to be such a small percentage of use
cases.

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


