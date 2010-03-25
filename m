Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0CYVAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:00:53 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63548 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CYVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QSDm2cJ+yr1P7vSljztISp+ewhYz3Kup8+cerYd5qESIP2OuD/lmqJbiAmdo7qR35A
         mg0Dr6g40VjBiPQJ7D1etSVNdfvhIFAD87egn0YMz9FlSRHIfoh9+8JvrWzqJId21C2F
         mVTF9R2JDii5JC07+q3JLYCw6ZFB+SgAYQ+vo=
MIME-Version: 1.0
In-Reply-To: <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
Date: Thu, 25 Mar 2010 22:00:49 +0100
Message-ID: <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: drepper@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX 2008 says, for exec*:

[ENOENT]
    A component of path or file does not name an existing file or path
or file is an empty string.
[ENOEXEC]
    The new process image file has the appropriate access permission
but has an unrecognized format.
[EINVAL]
    The new process image file has appropriate privileges and has a
recognized executable binary format, but the system does not support
execution of a file with this format.

None of these perfectly fit, but EINVAL seems the closest.
Note that ENOENT only specifies that the error happens for "not found"
problems in the function argument itself, so it is not really more
correct than the others.

Linux also defines ELIBACC (for a.out I believe):
#define ELIBACC         79      /* Can not access a needed shared library */

This also seems a possible candidate.

Not sure if it is safe to change this though, or what other systems do.
