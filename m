Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2JOVuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:50:00 -0400
Received: from shiva.jussieu.fr ([134.157.0.129]:62205 "EHLO shiva.jussieu.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2JOVt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:49:59 -0400
X-Greylist: delayed 796 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2012 17:49:59 EDT
X-Ids: 168
From: Juliusz Chroboczek <jch@pps.jussieu.fr>
To: linux-kernel@vger.kernel.org
Subject: Write is not atomic?
Date: Mon, 15 Oct 2012 23:36:15 +0200
Message-ID: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Miltered: at jchkmail.jussieu.fr with ID 507C81D0.001 by Joe's j-chkmail (http : // j-chkmail dot ensmp dot fr)!
X-j-chkmail-Enveloppe: 507C81D0.001/134.157.168.1/hydrogene.pps.jussieu.fr/hydrogene.pps.jussieu.fr/<jch@pps.jussieu.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Linux manual page for write(2) says:

    The adjustment of the file offset and the write operation are
    performed as an atomic step.

This is apparently an extension to POSIX, which says

    This volume of IEEE Std 1003.1-2001 does not specify behavior of
    concurrent writes to a file from multiple processes. Applications
    should use some form of concurrency control.

The following fragment of code

    int fd;
    fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC, 0666);
    fork();
    write(fd, "Ouille", 6);
    close(fd);

produces "OuilleOuille", as expected, on ext4 on two machines running
Linux 3.2 AMD64.  However, over XFS on an old Pentium III at 500 MHz
running 2.6.32, it produces just "Ouille" roughly once in three times.

Sorry for not being able to give more test cases, but I cannot easily
change either the filesystem or the kernel on the Pentium server.

-- Juliusz Chroboczek

P.S. I'll appreciate being copied with any replies.
