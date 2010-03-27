Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0C0Ov4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 10:51:56 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:38504 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0C0Ovy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 10:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LWq//MPcUETNh9IMiBO9w6bLu3Ywx0/33gHuRC3jKFFro4OxbIUC07f2mvaQmAi4PJ
         uzk2YHRBuvYWatSv8dUR1i4i6zkKwLR5+J29FF+frTR/EtROMkOAwGnm2jzvbQE3DfVr
         j4dw88kKHt+1XYBGVchQVvfXWmXzBXhwiIMPk=
MIME-Version: 1.0
In-Reply-To: <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	 <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	 <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
	 <ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
	 <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
Date: Sat, 27 Mar 2010 15:51:52 +0100
Message-ID: <ff13bc9a1003270751j5c138690p93afb7659d8d745d@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Olaf van der Spek <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That argumentation is bogus.  You wrote yourself, this situation isn't
> (and cannot) be described in POSIX.  For such cases the any error
> value is consistent with POSIX.

Sure, but that means POSIX also does not forbid changing it.

> Again: any value is as good as any other.  The existing value works
> and changing it breaks existing code.

Yes, this is an argument in favor of leaving it as is.

> Changing the error code alone achieves nothing.

If you were to change it to a new error value, such that
strerror(errno) == "unable to open ELF interpreter" (or similar), that
would just work.

The problem is that would only work after upgrading glibc, and would
probably break the error reporting code in RH shells if only the
kernel is upgraded.

A possibly better option is to add the ability to the kernel to report
extended error strings (was proposed some time ago), and use that.

It's a small issue, but I recently stumbled on it when running an x86
binary on an x86-64 machine lacking the compat libraries, and it's
quite suprising at first to have the shell claim the file does not
exist when it clearly does (and would be even more so for people who
don't know anything about executables or ELF).

The idea of parsing the ELF file in the shell seems quite ugly, since
you need to add a non-trivial piece of code at least to all shells and
all graphical file managers.
glibc itself could conceivably provide functions to do that
(strerror_for_exec* or exec*_with_extended_error ?).
