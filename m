Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0FGUpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:45:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44085 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0FGUpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bmQ6gSAC6KM76BnSYYUOsJOJMeDIPKNBnwMlKfWRj8CJ0kPiqcCNUVEGgJ3HhqAcfX
         /72XlnWyAZ64GtP1R8NrzPVBdO0DvVpi4OrH6CCOy7Fo5YJrxJY16pNkEEZUBL0xIRfs
         tLafrXZQi0062A1qtGpy4vhbjYDgP+Bbq95PA=
MIME-Version: 1.0
Date: Mon, 7 Jun 2010 14:45:38 -0600
Message-ID: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
Subject: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still seeing file system corruption after journal recovery in EXT3.
It's easy to reproduce, though the symptoms vary.  One way is to
rebuild a program and while the program is being compiled just shut
off power to the system by pulling the plug.  I am seeing the
/root/.viminfo file trashed after recovery if Vim was active during
poweroff.  I am also seeing object modules getting built which the LD
linker claims are "invalid" following a recovery event.  I suspect a
bug in the buffer cache since deleting the file still causes the old
data to be returned from buffer cache even when the sectors are
overwritten, but both are interrelated.  Seems in some way related to
EXT3 recovery which results in the buffer cache returning old sectors
and junk.

Not hard to reproduce, but the symptoms are always a little different
but the /root/.viminfo file getting nuked seems a common affect of
this bug.

Jeff
