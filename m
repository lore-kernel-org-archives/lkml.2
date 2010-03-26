Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0CZVGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:06:33 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:43809 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0CZVGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X4nyobqP4LYXOToQEYURxNXY2rX7Qfw7cA8NrqyHJ7ki2/oSc5SYJxXubPIKhm+k2x
         /WATjgtBNc4gJfYWP1hS8PLnFUlDrHigisp2lWcHOB2D/PU2WroU03MzsipfMWrCZCFs
         bI+ANM9z+SzMg2K2qdDR5kWvBz1MsxX1VJDP8=
MIME-Version: 1.0
In-Reply-To: <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	 <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	 <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
Date: Fri, 26 Mar 2010 22:06:31 +0100
Message-ID: <ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Olaf van der Spek <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> None of these perfectly fit, but EINVAL seems the closest.
>
> No.  ENOENT is the right value.

Not according to POSIX 2008, which does not explicitly specify this case.

Again, it says:
[ENOENT]
    A component of <i>path</i> or <i>file</i> does not name an
existing file or <i>path</i> or <i>file</i> is an empty string.

Here "path" and "file" refer to the argument to the C function and
"component" refers to the tokens obtained after splitting using "/" as
a separator.
POSIX 2008 doesn't talk at all about dependencies of the executables.

POSIX 2008 mandates EINVAL if you interpret "executable format" as
being "ELF executable with interpreter /lib/FOO" as opposed to just
"ELF", or if you interpret "architecture" as including the ELF
interpreter name in addition to the machine type.

By the way, is there any way to do this in the shell other than
including an ELF parser or assuming the ELF interpreter is missing if
the kernel returns ENOENT but the file exists and has an ELF
signature? (both of these solutions seem quite unsatisfactory)
