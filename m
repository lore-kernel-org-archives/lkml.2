Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab0FEW5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:57:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59074 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468Ab0FEW5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=u6TUzU19YMZMT1Qe2sSLvrr65lLKdRU/GDWyoPrAd15m86a/QhaHJD+INSEaGDmhTb
         97dAtZWNPQTuCGywbzdy4sUsOVWeQjkTbk4Pv3VpVieM+RrbM0UpIWBtjEOq8GvgEist
         kpt048kkkfq71POrTSwjuwJq64fU6cnVqYw9I=
MIME-Version: 1.0
Date: Sat, 5 Jun 2010 16:57:33 -0600
Message-ID: <AANLkTink4RNS3UsfRjyj3DfIH0wEeAj1wtKzBUgbvU8m@mail.gmail.com>
Subject: 2.6.34 general comments
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing a lot of file system corruption with temporary files on EXT3.
/root/.viminfo gets trashed a lot if the system is not shut down.
EXT3 recovery during boot produces corrupted files.  Does not happen
on 2.6.28.

Seeing system lockups on my Compaq Presario 2200 even after just
letting it boot up and not even logging in.

Seeing the /boot/grub/grub.conf file getting trashed and replaced with
binary junk during EXT3 recovery if system not shutdown properly.

At any rate, I am not accustomed to seeing file system corruption in
EXT3 like I am seeing even when I abuse the shit out of the system
like I normally do during development
of kernel modules.

Overall, performance on 2.6.34 is a lot better then I have ever seen
before on Linux with disk I/O and the kernel behaves a lot better with
heavy IO.  So that's a plus.

Also, the hw_breakpoint subsystem has a lot of issues with other
debuggers using the notify_die handlers since it hooks first.
resident debuggers are just broken if it is left active.  Clearing of
DR6 in traps.c under x86 also is troublesome and will break any
loadable debugger.  a better approach may be needed.

Jeff
