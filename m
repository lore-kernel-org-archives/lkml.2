Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab1F3Gbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:31:47 -0400
Received: from 1wt.eu ([62.212.114.60]:37312 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1F3Gbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:31:42 -0400
Date: Thu, 30 Jun 2011 08:31:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: ????????? <faye.zixun@gmail.com>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Subject: Re: [stable] Ioctl in 2.6.35.22 change the argument value?
Message-ID: <20110630063130.GC26670@1wt.eu>
References: <BANLkTinZphAp1QxzddUMciwyhKXdo4y57Q@mail.gmail.com> <BANLkTin9JkWbOHjbZSRTHye+sbr3HpLrBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin9JkWbOHjbZSRTHye+sbr3HpLrBw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 29, 2011 at 11:09:26PM -0700, ????????? wrote:
> Hello everybody,
> 
> When I want to get the block size about the block device(DM or real),I
> use the system API like "ioctl(int fd, BLKGETSIZE,long size)".
> Everything works fine. But when I pass the third parameter whose type
> is "int", the first parameter fd will be changed to zero. It only
> happened on x86_64 and 2.6.35 ,on  2.6.38 and 32bit will not occur,
> I've already tested on them.
> (My PC:Linux server-group 2.6.35-22-server #33-Ubuntu SMP Sun Sep 19
> 20:48:58 UTC 2010 x86_64 GNU/Linux)
> here is the test code:
> int main(){
>         int fd;
>         int blksize ;
>         fd = open("/dev/sda",O_RDONLY,0);
>         ioctl(fd, BLKGETSIZE,&blksize) ;
>         close(fd);
> }
> If I change the fd type as long( int fd ==> long fd ) , won't occur
> again. I quite sure the ioctl syscall when return to userspace changes
> the fd's value.

This is expected, check the ioctl list (man ioctl_list) :
       0x00001260   BLKGETSIZE   unsigned long *

So it returns a long, and you need to have blksize declared as long
and not as int. On 32-bit systems, both are the same size so your
bug has no effect.

Please also note that this is irrelevant to the stable list.

Regards,
Willy

