Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0G2Bal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 21:30:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54959 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0G2Bak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 21:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SxoX3tqg2L6r/7rmsViDZYZntB1Yteg4iq4xlyB/7EqhBG1wssdnKjsgAbWQyf29QG
         o7JIDzfLMql232qwWJbGIGyBhK5jYlgRPJk8F5b9rEKnQewwz5EJrzKWKTTuGxcU4Ypl
         DCHV8ImAE5I6a6L5+C28SsYsbWZQeMkEUHD7Q=
MIME-Version: 1.0
Date: Thu, 29 Jul 2010 02:30:37 +0100
Message-ID: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com>
Subject: kcryptd oops when resuming with TuxOnIce with KDB oops afterwards
From: Pedro Ribeiro <pedrib@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>, tuxonice-devel@tuxonice.net,
        kgdb-bugreport@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>,
        dm-crypt@saout.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I hit a bug when resuming with TuxOnIce. At the middle of a resume, it
says Compress Read -22 and locks up. I caught the stack trace with kdb
and took photos of that.
I'm running 2.6.35-rc6 on a Lenovo T400. I have an encrypted LUKS
partition (aes-cbc-essiv-128) which contains an LVM2 with my root,
swap and home partitions inside.

It seems that kcryptd caused the trouble. I've had other lockups with
TuxOnIce that relate to kcryptd too, but I never caught them with kdb,

After printing the stack trace I decided to see the output of the ps
command. As I was scrolling the processes shown, kdb oops'ed and
called itself. I also took photos of that kdb's own stack trace. I
then tried the ps command again, but this time the stack trace was
looping every few seconds (I took another photo of that). After a
while it just panicked and kept calling itself on a loop. I rebooted
and was able to successfully resume the TuxOnIce image.

The stack trace means little to me, but might be helpful to you.

The photos are:
kcryptd_oops [1,2,3] - TuxOnIce compress read -22 error
kdb_oops [1,2,3,4] - KDB oopses when scrolling output of kdb ps command
kdb_blows_up - final stack trace being shown in a cycle before PANIC:
recursive entry into debugger and locking up completely

The files are in kcryptd_kdb_oopses.tar.gz (about 4.7 mb) located here
http://www.mediafire.com/file/uum6y1hwfk90124/kcryptd_kdb_oopses.tar.gz
. They should stay there at least 30 days.

Sorry for the file size but they are good quality pictures.

Regards,
Pedro
