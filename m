Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1FRSXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:23:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58016 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1FRSW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <1308418985.3539.58.camel@edumazet-laptop>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	<1308418985.3539.58.camel@edumazet-laptop>
Date: Sat, 18 Jun 2011 11:22:57 -0700
Message-ID: <BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
Subject: Re: Does Linux select() violate POSIX?
From: Nemo Publius <nemo@self-evident.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, thank you for your reply.

On Sat, Jun 18, 2011 at 10:43 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 18 juin 2011 à 10:06 -0700, Nemo Publius a écrit :
>> Suppose I  have a file descriptor referencing a TCP/IP socket in blocking mode.
>>
>> Suppose select() reports that the descriptor is ready for reading.
>>
>> If I then call recv() on that descriptor, can it _ever_ block?
>>
>>
>> According to the Linux select man page
>> (http://linux.die.net/man/2/select), the answer is yes:
>> ...
>
> Only UDP can currently do that, not TCP, if NIC did not already verified
> the checksum.
>
> So the answer to your question is no.

You mean the answer happens to be "no" for reading a TCP socket with
the current Linux implementation, but that is not considered part of
the interface, so the behavior could change in the future and so I
cannot depend on it?

>> According to the POSIX specification for select
>> (http://pubs.opengroup.org/onlinepubs/9699919799/functions/select.html),
>> the answer is no:
>> ...
>
>
> We dont care, since every sane application using select() should also
> use socket in non blocking mode.

This is simply not true for any POSIX-compliant operating system.
Which in this case happens to include every Unix ever written since
the beginning of time, apart from Linux.

Put another way...  The whole point of the POSIX spec is to allow me
to write portable code.  If every random Unix implementation makes up
its own mind about what is "sane" and violates the spec in arbitrary
and unpredictable ways, what is the point of having a spec?

> Between time select()/poll() says 'OK you can go', and time you enter
> kernel, conditions might have changed. For example, maybe kernel memory
> is not available and a send() would _block_, even if socket queue is
> empty.

Sounds like a kernel bug.
