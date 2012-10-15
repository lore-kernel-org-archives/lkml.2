Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2JOWVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:21:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49577 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2JOWVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
Date: Tue, 16 Oct 2012 02:21:36 +0400
Message-ID: <CAMo8Bf+w7S_O2XYin7hnuobpBncZxZBq2=nAQ+Jrszif979xKQ@mail.gmail.com>
Subject: Re: Write is not atomic?
From: Max Filippov <jcmvbkbc@gmail.com>
To: Juliusz Chroboczek <jch@pps.jussieu.fr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 1:36 AM, Juliusz Chroboczek <jch@pps.jussieu.fr> wrote:
> Hi,
>
> The Linux manual page for write(2) says:
>
>     The adjustment of the file offset and the write operation are
>     performed as an atomic step.
>
> This is apparently an extension to POSIX, which says
>
>     This volume of IEEE Std 1003.1-2001 does not specify behavior of
>     concurrent writes to a file from multiple processes. Applications
>     should use some form of concurrency control.
>
> The following fragment of code
>
>     int fd;
>     fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC, 0666);
>     fork();
>     write(fd, "Ouille", 6);

You don't check return code here, does write succeed at all?

>     close(fd);
>
> produces "OuilleOuille", as expected, on ext4 on two machines running
> Linux 3.2 AMD64.  However, over XFS on an old Pentium III at 500 MHz
> running 2.6.32, it produces just "Ouille" roughly once in three times.

Does it ever produce e.g. OuOuilleille (as this is what atomicity is about
here)?

-- 
Thanks.
-- Max
