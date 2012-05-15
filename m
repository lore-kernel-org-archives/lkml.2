Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966889Ab2EOVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:08:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61400 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966814Ab2EOVIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <4FA17F6A.9000606@genband.com>
References: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
	<4FA17F6A.9000606@genband.com>
Date: Tue, 15 May 2012 14:08:42 -0700
X-Google-Sender-Auth: g_O2Zx9wQ71HPx5e6xA8hqV-K94
Message-ID: <CANkdjvYL8cne9xmgjFcFDbn74ss6WzXTDXY34f_MWcsaDKeTDg@mail.gmail.com>
Subject: Re: read() syscall slowing down due to other threads?
From: George Porter <gmporter@cs.ucsd.edu>
To: Chris Friesen <chris.friesen@genband.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the response--we did play around with core affinity, and it
does make a difference for sure.  The major thing was turning off HP's
power management stuff, and putting the BIOS into high-performance
mode.  That helped a lot.

Thanks, George

On Wed, May 2, 2012 at 11:39 AM, Chris Friesen
<chris.friesen@genband.com> wrote:
> On 05/01/2012 12:03 AM, George Porter wrote:
>
>> However, if I start doing more computation on those other threads, the
>> read() syscalls take longer to read the same amount of data,
>> eventually slowing down to 50 MBps (50% slower).  I've used
>> setaffinity() to isolate the Reader threads to one set of cores, and
>> the compute threads to a different set of cores, and so I don't think
>> it is CPU/scheduling interference.
>>
>> Thoughts?  Has anyone run into this before?
>
>
> If you're using hyperthreading you may want to try it with either putting
> the computation threads on the siblings of the cpus for the reader threads
> (to share cache) or else not on the siblings of the cpus for the reader
> threads (to minimize contention of cpu resources).
>
> Similarly, you may want to play with wither or not the threads are on the
> same or different sockets.
>
> Chris
>
> --
> Chris Friesen
> Software Developer
> GENBAND
> chris.friesen@genband.com
> www.genband.com
