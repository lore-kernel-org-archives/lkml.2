Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1JAMT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 08:19:26 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:53512 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1JAMTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 08:19:19 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr>
	<201109271539.21533.arnd@arndb.de> <878vp96fhl.fsf@free.fr>
	<201109281445.47715.arnd@arndb.de>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 01 Oct 2011 14:19:08 +0200
In-Reply-To: <201109281445.47715.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 28 Sep 2011 14:45:47 +0200")
Message-ID: <87y5x4hpkz.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> I generally recommend removing debug messages like this entirely from
> production code. If you need them on production systems, that is an indication
> that the code quality is not good enough.
Perhaps.
But when you create a driver without any specification, and you release it to
the communauty, there will be unmet behaviours. So, when someone will ask me
"why in my board XXX my docg3 can't read data ?" how can I improve the driver
without any traces ?

> Enabling the debug output like
> this also creates a lot of almost identical strings, which you don't need
> if you turn it into an extern function that does
>
> 	static const char docseq[] = {
> 		[DOC_SEQ_RESET]		 = "reset",
> 		[DOC_SEQ_PAGE_SIZE_532]	 = "page_size_532",
> 	};
> 	dev_dbg(dev, "doc_flashSequence: %02x %s\n", docseq[seq]);
> with exactly the same output.
That doesn't look very good, as the sequence numbers are sparse numbers, and we
can finish with an array with values (0, 3, 8, 0xff) filled, and all the
remaining are null pointers (as these sequence numbers don't exist).


> Or you could turn the entire tracing into trace events and do the parsing
> in user space, which seems appropriate if you frequently need to trace
> these.
This looks much much better. I'll have a peek into that, as only (io_address,
read/write, width, value) could be dumped, and userland application could
translate it into sequence/nop/flashcontrol ... etc ...

-- 
Robert
