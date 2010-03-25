Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0CYT3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:29:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab0CYT3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CwxajbJwdtJHk4ubJ/rNd52gUt3QZizHzBJCW8qAt6GDMn3hV11Cr0uoF75thyePU1
         R2GdXNNHTMMXbBRxy/MM10lmB/uLCGBwgDJlIfoiReraosxdAoATjcaTEFHo6JbdT33X
         jNLWUQKACgB6ZKEO3jR4j/IMs8fE2GSiNhAjs=
MIME-Version: 1.0
In-Reply-To: <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
Date: Thu, 25 Mar 2010 20:29:14 +0100
Message-ID: <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: drepper@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 11:45 PM,  <drepper@gmail.com> wrote:
> On Wed, Mar 24, 2010 at 15:37, Olaf van der Spek <olafvdspek@gmail.com>
> wrote:
>>
>> Why not?
>> It's an improvement IMO, although it could be better.
>
> It's blatantly wrong.  There is no dynamic linker.  ENOEXEC means the file
> exists but is not of the right format.

That sounds closer to the actual error than ENOENT.

ENOENT: The file filename or a script or ELF interpreter does not
exist, or a shared library needed for file or interpreter cannot be
found.
ENOEXEC: An executable is not in a recognized format, is for the wrong
architecture, or has some other format error that means it cannot be
executed.

ENOENT shouldn't be overloaded like this, as it's common meaning is:
file not found. So it shouldn't be returned if the argument to execve
is actually found.

Olaf
