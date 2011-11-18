Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1KRJyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:54:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33739 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KRJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:53:51 -0500
Message-ID: <4EC62B2A.5080606@evidence.eu.com>
Date: Fri, 18 Nov 2011 10:53:46 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] drivers/base/node.c: fix compilation error
References: <4EC4DD20.6080201@evidence.eu.com> <20111117175210.GE13208@suse.de>
In-Reply-To: <20111117175210.GE13208@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/11/2011 18:52, Greg KH ha scritto:
> On Thu, Nov 17, 2011 at 11:08:32AM +0100, Claudio Scordino wrote:
>> Hi all,
>>
>> 	the current mainline kernel gives a "directives may not be used
>> inside a macro argument" error message when compiled for the
>> cris architecture.
> 
> Is this because cris is using an older version of gcc, or is it due to
> something else?

Hi Greg.

The compiler I used it's still the same I used in the past (i.e., gcc 3.2.1):

/usr/local/cris/bin/cris-axis-linux-gnu-gcc -v
Reading specs from /usr/local/cris/lib/gcc-lib/cris-axis-linux-gnu/3.2.1/specs
Configured with: /home/cii/cris-dist/./gnu-toplev/configure --enable-version-specific-runtime-libs --disable-nls --target=cris-axis-linux-gnu --without-newlib --with-headers=installed --enable-languages=c,c++ --enable-shared --enable-threads=posix --prefix=/usr/local/cris
Thread model: posix
gcc version 3.2.1 Axis release R64/1.64

It's contained inside the cris-dist_1.64-1_i386.deb package. I don't
know if a newer compiler has been made available by the Axis group.

However, I never found this issue when compiling  /fs/proc/meminfo.c in
the past.  Therefore, I couldn't find the same error in
drivers/base/node.c either.

I suspect that  /fs/proc/meminfo.c has been recently changed, and then the
same (old) compiler started complaining.

The two patches I have sent are very trivial, but allow to fix those
build problems.

Best regards,

	Claudio

