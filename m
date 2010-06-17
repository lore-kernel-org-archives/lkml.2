Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab0FQPLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:11:03 -0400
Received: from v002983.home.net.pl ([212.85.107.189]:55643 "HELO
	v002983.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932900Ab0FQPLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:11:00 -0400
From: Hubert Kario <hka@qbs.com.pl>
Organization: QBS - Quality Business Software
To: "David Pottage" <david@electric-spoon.com>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Thu, 17 Jun 2010 17:04:13 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-ARCH; KDE/4.4.4; i686; ; )
Cc: "Nikanth Karthikesan" <knikanth@novell.com>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Christoph Hellwig" <hch@lst.de>,
       "Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
References: <201006092035.46481.knikanth@novell.com> <201006151611.36443.knikanth@novell.com> <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
In-Reply-To: <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006171704.14541.hka@qbs.com.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 June 2010 17:16:06 David Pottage wrote:
> On 15/06/10 11:41, Nikanth Karthikesan wrote:
> > I had a one-off use-case, where I had no free-space, which made me
> > think along this line.
> > 
> > 1. We have the GNU split tool for example, which I guess, many of us
> > use to split larger files to be transfered via smaller thumb drives,
> > for example. We do cat many files into one, afterwards. [For this
> > usecase, one can simply dd with seek and skip and avoid split/cat
> > completely, but we dont.]
> 
> I am not sure how you gain here as either way you have to do I/O to get
> the split files on and off the thumb drive. It might make sense if the
> thumb drive is formated with btrfs, and the file needs to be copied to
> another filling system that can't handle large files (eg FAT-16), but I
> would say that is unlikely.
> 

But you do have to do only half as much of I/O with those features 
implemented.

The old way is:
1. Have a file
2. split a file (in effect use twice as much drive space)
3. copy fragments to flash disks

The btrfs way would be:
1. Have a file
2. split the file by using COW and referencing blocks in the original file (in 
effect using only a little more space after splitting)
3. copy fragments to flash disks

the amount of I/O in the second case is limited only to metadata operations, 
in the first case, all data must be duplicated

-- 
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawerów 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarządzania Jakością
zgodny z normą ISO 9001:2000
