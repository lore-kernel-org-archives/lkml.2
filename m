Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1EJPSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:18:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34436 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1EJPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Jdy1pss/7XU4AyTEFMONHupvUzDLMy5zMJRDLua6SZ7g4pvGbceHQ/AVW5Yb+W50QJ
         9xVvG9PDXFcNbSAxxMiPQAO5hU+Y+oyX+N+R+/OMTjQ/L/C/eazvIWIdLXqTPECa1AE0
         9hbJcRCiOZU1TikY3LfqeNOXJ1F30p2kjWVio=
MIME-Version: 1.0
Date: Tue, 10 May 2011 11:18:05 -0400
Message-ID: <BANLkTik8DBNKrFE_hZi5FtxUY7Hw_BBR2Q@mail.gmail.com>
Subject: selinux troubleshooting
From: Mark Leeds <markleeds2@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all: I'm a total newbie with the kernel and I've never used this
list before so excuse me if this is not the correct place to ask this
question. or if I don't follow the positing directions correctly.

I am running fedora 14.0 and when I do uname - a, I get

Linux localhost.local 2.6.35.10-74.fc14.i686 #1 SMP Thu Dec 23
16:17:40 UTC 2010 i686 i686 i386 GNU/Linux
:/home/markleeds/rpmbuild#

But today I've been trying to run an R  job ( see www.r-project.org
for details about R )  in the background and
it just dies without any error messages. well, it does in the sense
that the operating system hangs and I need to
shut down the computer by pulling the plug out and putting it back in.
There's no other way as far as
I can tell because the computer just freezes essentially.

Then I was poking around to see if I could find any info I went into
the selinux troubleshooter.

there is a red dot and two yellow dots below it. each says something.

next to the red dot:  "if you do not think /usr/lib/R/bin/exec/R
should need to map low
memory in the kernel"

next to the yellow dot:  "if you want to control the ability to mmap a
low area of teh address space, as confugured by
/proc/sys/kernel/mmap_min_addr".

next to the second yellow dot: "if you believe that R should be
allowed mmap_zero access on the
unknown mprotext by default".


In each case, if I click one of the dots, it gives a suggestion on
what to do  on the right.


#==============================================================================

red dot suggestion: "you may be under attack by a hacker, this is a very
dangerous access. Contact your security administrator and report this issue"


first yellow dot suggestion: You must tell SELinux about this by
enabling the 'mmap_low_allowed' boolean. setsebool -P mmap_low_allowed
1


second yellow dot suggestion.

You should report this as a bug. You can generate a local policy
module to allow this access.
Allow this access for now by executing: # grep R /var/log/audit/a
udit.log | audit2allow -M mypol

# semodule -i mypol.pp

#==============================================================================


thank you for any suggestions on what the best thing to do is
and I'm sorry if this is not the correct mailing list.


                                                        mark
