Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1BAXZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:25:48 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34335 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1BAXZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:25:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KUrKXwl49T/MIxSJ+9qYXQcbZfJHl5kgWIhprw1xwizjNSUxUQZEQrTa5eZR/iaLJd
         p0YSFg0NSPRY1F0vFCLh3ZWW+fekPhzVGg8w/1iJWtcUoYG4rbFp2d6LUyCIXFPEM8xH
         JcQqvODhEbXnZaj2BF84lYtsDlwabDVTxZnFE=
MIME-Version: 1.0
Date: Wed, 2 Feb 2011 00:25:46 +0100
Message-ID: <AANLkTikFBZT6+8_MAJ6xd+uPrwJnomPbhX9toNuncm0N@mail.gmail.com>
Subject: Change DECOMPRESS_LZMA to boolean
From: Marcel Korpel <marcel.lists@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Jan 2010 00:55:55 +0000 Phillip Lougher wrote:
> Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > When CONFIG_SQUASHFS=m and CONFIG_DECOMPRESS_LZMA=m, decompress_lzma
> > is built but then discarded from the library because no built-in code
> > uses it, so change it from a lib- to an obj- to force it to be kept
> > in the library.
> >
> > ERROR: "unlzma" [fs/squashfs/squashfs.ko] undefined!
> >
>
> Thanks for fixing this, I should have spotted it in my various
> config tests but didn't.  I could add this to my squashfs-next patches
> to stop the linux-next tree breakage, however, should it go into
> Michal's kbuild -next tree instead?
>
> This patch raises a small additional issue, why is DECOMPRESS_LZMA
> (and DECOMPRESS_GZIP/DECOMPRESS_BZIP2) and defined as tristate?
> None of the above compressors can be built as modules.

I just ran into this exact same issue, when disabling DEV_BLK_INITRD
and setting SQUASHFS to "m" and selecting SQUASHFS_LZMA. The option
then evaluates to:

  DECOMPRESS_LZMA [=m]
  Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=n] ||
  SQUASHFS_LZMA [=y] && MISC_FILESYSTEMS [=y] && SQUASHFS [=m]

With these settings the linker complains:

  Error: "unlzma" [fs/squashfs/squashfs.ko] undefined

Please change DECOMPRESS_LZMA (and perhaps the other DECOMPRESS_*
symbols) to boolean.

Regards,
Marcel
