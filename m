Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0FUGm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 02:42:28 -0400
Received: from smtp.mmd.net ([80.83.0.30]:41408 "EHLO smtp.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab0FUGmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 02:42:25 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 02:42:25 EDT
Message-ID: <4C1F087E.7070000@ebts.fi>
Date: Mon, 21 Jun 2010 09:36:46 +0300
From: Aleksandr Koltsoff <aleksandr.koltsoff@ebts.fi>
Organization: EKE Building Technology Systems
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RFC: Exporting NOCMTIME to userspace
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm currently investigating various techniques to lessen the block erase
load on consumer nand flash devices (usb-ftl + nand and sd-ftl + nand).
While SSDs are of no current interest to me, this use case applies to
them as well.

The use case I'm working with is a set of pre-allocated files that get
updated periodically with data that overwrites some of the existing
data. The files never grow/shrink. (rrdtool is a good example of such
behaviour).

I've been looking for a mechanism to avoid writes going to the inodes of
the files, but have been unsuccessful so far. At least ctime will get
updated periodically.

In this use case, the timestamps are really irrelevant (the file content
contains timestamps), and I'd like to avoid updating the inodes
all-together. What happens now is extra block erasures when they aren't
actually needed or wanted.

While there is a flag in the inode structure to stop m/ctime updates,
this flag is not currently exported to userspace (similar to O_NOATIME).
I feel that the least intrusive way would be such a flag, since this is
certainly an application/file-specific problem and a mount-point flag
would be not so useful.

How do people feel about this? I'm aware of some of the ramifications of
not updating ctime (regarding dumping filesystem changes, and making
life more difficult for rsync/mtime-based backups). However, I still
feel quite strongly that providing an option for applications to avoid
extra nand erases would be a good thing.

On the other hand, if someone can suggest a way to avoid timestamp
updates/causing inode writes, I'm all ears and eyes. (using the
block-layer directly or writing a custom fs is not really an elegant
solution, IMO).

Thank you for your time & best regards,

Aleksandr Koltsoff
