Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab0LTXIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:08:44 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56345 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135Ab0LTXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:08:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=M/4IMSNY/hwLet9IkdtS0J6mSRllSfapIsA9LtFWb+uMm2u94Oy2xsDTSxyG/R2Lg4
         uM2vsree49Hc/08VbCFlID7T2AK5H7jhaelf70P61eXcZHxAzc6MZyXrmr1UgLpRNJ0Z
         6tWYXxF0bJptnn7w5xmAww6Cnwcg01sJVYJ7I=
MIME-Version: 1.0
From: AJ ONeal <coolaj86@gmail.com>
Date: Mon, 20 Dec 2010 16:08:21 -0700
Message-ID: <AANLkTings_UPY4xSGe39X3GB8g9V=betWASk9YhspiTN@mail.gmail.com>
Subject: SIGBUS caused by mmap and memcpy that doesn't go away after
 application restart
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After posting to my local LUG I was told to ask about the possibility
of a kernel bug here


I have an application which runs for several hours in the same loop
correctly, but eventually dies with SIGBUS.

If I try to start the application again it immediately exits with
SIGBUS and will not work until rebooted.

gdb reports
Program received signal SIGBUS, Bus error.
0x401bd354 in memcpy () from /lib/libc.so.6
(gdb) bt
#0  0x401bd354 in memcpy () from /lib/libc.so.6
#1  0x0000929c in capture_file_write ()
#2  0x0fefeb0a in ?? ()
#3  0x0fefeb0a in ?? ()

Any ideas on what causes this error?
How do I go about finding what #2 and #3 are?


The system is a ARM OMAP3530 (Gumstix Overo). The kernel is 3.6.36.

This is the application flow:

count = 0
do
    outfile = /dev/shm/output.{#count}.dat
    data = read logged.dat for 512kb
    unlink outfile if exists
    truncate outfile to 512kb
    outfile_p = mmap outfile
    memcpy data outfile_p
    munmap
    count += 1
    if count > MAX; count = 0
    advance or rewind logged.dat
loop

I can post a link to a gist of the source upon request.

AJ ONeal
