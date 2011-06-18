Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab1FRRGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:06:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44325 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1FRRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:06:20 -0400
MIME-Version: 1.0
Date: Sat, 18 Jun 2011 10:06:18 -0700
Message-ID: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
Subject: Does Linux select() violate POSIX?
From: Nemo Publius <nemo@self-evident.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose I  have a file descriptor referencing a TCP/IP socket in blocking mode.

Suppose select() reports that the descriptor is ready for reading.

If I then call recv() on that descriptor, can it _ever_ block?


According to the Linux select man page
(http://linux.die.net/man/2/select), the answer is yes:

"Under Linux, select() may report a socket file descriptor as "ready
for reading", while nevertheless a subsequent read blocks. This could
for example happen when data has arrived but upon examination has
wrong checksum and is discarded. There may be other circumstances in
which a file descriptor is spuriously reported as ready."


According to the POSIX specification for select
(http://pubs.opengroup.org/onlinepubs/9699919799/functions/select.html),
the answer is no:

"A descriptor shall be considered ready for reading when a call to an
input function with O_NONBLOCK clear would not block, whether or not
the function would transfer data successfully. (The function might
return data, an end-of-file indication, or an error other than one
indicating that it is blocked, and in each of these cases the
descriptor shall be considered ready for reading.)"


There are only three possibilities:

1) I am mis-reading the POSIX spec.
2) The Linux select() man page is wrong.
3) Linux select() violates the POSIX spec.

So, which is it?

Thanks!
