Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab0JLA6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:58:55 -0400
Received: from nm30.bullet.mail.sp2.yahoo.com ([98.139.91.100]:36833 "HELO
	nm30.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755422Ab0JLA6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:58:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 359780.96406.bm@omp1021.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=Ju2txGAHO7O3e/7Kh4OSh9OjnG9dpfSBAH4UOvLTmLbq7k3k0y2Pkc9wQd9NCxHCn1wkQ28GaemeYoTyuKiOBNuVqbBtiH62tcyCbdeH9q1AedoE2bVx9TVE0YLO+VegoiVprmzDtFsyVXWKkzGYOjX3xWFbHSiz1E9lmaN5if4=;
Message-ID: <895917.46195.qm@web113418.mail.gq1.yahoo.com>
X-YMail-OSG: 3Pp5HQUVM1mpdfijVqvABzB3M7fNHl9XItKgoFplqcOsJ0f
 ..H9tLcWJJroke0kuSjEnJMhzO6gJbsZN_yY2zA5kUwV7Lr3fHO.xOB2Gazu
 sWHyvZlvIL3XcHHRyDCjYkfAEX9sxQBgY09HH5lC2HqzHpj3QXOYBgSID1AW
 KIWRtUMsgeM1DBeu4dBQZ4PpyVlOiE7uli.EC9weTivRBFkgyMpg5dJns2KQ
 DYuAz4zl1WDZabEM03_fpZoSMt.XAzA5T
X-Mailer: YahooMailRC/504.5 YahooMailWebService/0.8.106.282862
References: <633175.66987.qm@web113411.mail.gq1.yahoo.com> <E1OyL6H-0002wC-GV@pomaz-ex.szeredi.hu>
Date: Mon, 11 Oct 2010 17:58:52 -0700 (PDT)
From: Neeraj Kumar <neeraj.kumar01@ymail.com>
Subject: Re: Doing a zero-copy move of data from a kernel buffer to hard disk
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1OyL6H-0002wC-GV@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Mon, 20 Sep 2010, Neeraj Kumar wrote:
 >> I am trying to move data from a buffer in kernel space into the hard
 >> disk without having to incur any additional copies from kernel buffer to
 >> user buffers or any other kernel buffers. Any ideas/suggestions would be
 >> most helpful.
 >> 
 >> The use case is basically a demux driver which collects data into a
 >> demux buffer in kernel space and this buffer has to be emptied
 >> periodically by copying the contents into a FUSE-based partition on the
 >> disk. As the buffer gets full, a user process is signalled which then
 >> determines the sector numbers on the disk the contents need to be copied
 >> to.
 >> 
 >> I was hoping to mmap the above demux kernel buffer into user address
 >> space and issue a write system call to the raw partition device. But
 >> from what I can see, the this data is being cached by the kernel on its
 >> way to the Hard Disk driver. And so I am assuming that involves
 >> additional copies by the linux kernel.

>Isn't this functionality already served by relayfs?

I could not figure out how relayfs could help me.

 >> At this point I am wondering if there is any other mechansim to do this
 >> without involving additional copies by the kernel. I realize this is an
 >> unsual usage scenario for non-embedded environments, but I would
 >> appreciate any feedback on possible options.
 >> 
 >> BTW - I have tried using O_DIRECT when opening the raw partition, but
 >> the subsequent write call fails if the buffer being passed is the
 >> mmapped buffer.

>The other zero-copy  mechanism is splice(2).

I looked at the implementation of splice(). It looks promising. I have 2 more 
questions related to it:
1. SPLICE_F_MOVE which is needed for zero copy movement of pages is defined as 
no op in the kernel code.
    Does splice still tries for zero copy movement?

2. I may need to implement splice_read() and splice_write() for the demux 
driver.  I did not find any other
 driver making use of these interfaces in the kernel except file system. Is 
there any sample code available
which could help me to understand/implement splice() interfaces in a better way?


Thanks,
Miklos


      
