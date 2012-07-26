Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2GZOaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:30:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55845 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GZOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:30:11 -0400
MIME-Version: 1.0
Date: Thu, 26 Jul 2012 10:30:09 -0400
Message-ID: <CAG4AFWa5qKzUqmR+3o4Od_jBt0PT-osUPczbh=VhvLh45+E6ng@mail.gmail.com>
Subject: Question about the fallocate system call
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just have a simple question about fallocate.

I want to test the punch hole function of fallocate(). So I wrote such
a simple program:

yosemite:/mnt # cat test.c
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <linux/fs.h>
#include <linux/falloc.h>

int main(void)
{
        int fd;

        fd = open("testfile", O_RDWR);
        fallocate(fd,FALLOC_FL_PUNCH_HOLE,0,500*1024*1024);
        close(fd);

        return 0;
}

I created a file called "testfile" whose size is 1GB, however, when I
run the above program, the size of the testfile simply won't change,
if I use stat command to check the file status, nothing is changed when I
execute the above program. My filesystem is ext4, as I understand,
ideally when I run the above program, the file size should decrease
from 1GB to 512MB, is there anything wrong with the program or I just
understood incorrectly?

Thank you for any inputs/comments.

-Jidong
