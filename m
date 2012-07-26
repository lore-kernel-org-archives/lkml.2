Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2GZSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:16:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab2GZSQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:16:40 -0400
Message-ID: <50117829.5040303@draigBrady.com>
Date: Thu, 26 Jul 2012 18:02:33 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jidong Xiao <jidong.xiao@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Question about the fallocate system call
References: <CAG4AFWa5qKzUqmR+3o4Od_jBt0PT-osUPczbh=VhvLh45+E6ng@mail.gmail.com>
In-Reply-To: <CAG4AFWa5qKzUqmR+3o4Od_jBt0PT-osUPczbh=VhvLh45+E6ng@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 03:30 PM, Jidong Xiao wrote:
> Hi,
> 
> I just have a simple question about fallocate.
> 
> I want to test the punch hole function of fallocate(). So I wrote such
> a simple program:
> 
> yosemite:/mnt # cat test.c
> #include <fcntl.h>
> #include <errno.h>
> #include <stdio.h>
> #include <stdint.h>
> #include <linux/fs.h>
> #include <linux/falloc.h>
> 
> int main(void)
> {
>         int fd;
> 
>         fd = open("testfile", O_RDWR);
>         fallocate(fd,FALLOC_FL_PUNCH_HOLE,0,500*1024*1024);
>         close(fd);
> 
>         return 0;
> }
> 
> I created a file called "testfile" whose size is 1GB, however, when I
> run the above program, the size of the testfile simply won't change,
> if I use stat command to check the file status, nothing is changed when I
> execute the above program. My filesystem is ext4, as I understand,
> ideally when I run the above program, the file size should decrease
> from 1GB to 512MB, is there anything wrong with the program or I just
> understood incorrectly?
> 
> Thank you for any inputs/comments.

code looks OK,
but you're not checking the return from fallocate().
I'm guessing it's returning -1 with errno = ENOTSUP

cheers,
Pádraig.
