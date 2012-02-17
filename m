Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2BQVN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:13:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51018 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2BQVNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:13:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alcooperx@gmail.com designates 10.52.29.241 as permitted sender) smtp.mail=alcooperx@gmail.com; dkim=pass header.i=alcooperx@gmail.com
MIME-Version: 1.0
Date: Fri, 17 Feb 2012 16:13:54 -0500
Message-ID: <CAOGqxeWjtr=SOY83ZFEdwJXXatqLLEN6SHre9-0DfeJfcyBhKQ@mail.gmail.com>
Subject: Stack unwind across signal frame
From: Alan Cooper <alcooperx@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a problem on both 2.6.37 and 3.3 MIPS kernels where I can't
unwind through a MIPS signal frame. It looks like this is caused by
the VDSO code that was added 2/2010. When the unwinder tries to find
the frame info for the caller of the signal handler (the trampoline in
VDSO), it can't find the eh_frame info because the address is in the
VDSO area and stops unwinding. It looks like other platforms solve
this by adding the eh_frame info for the VDSO area so the lookup
works.

This problem ends up breaking pthread cleanup for C++ programs because
the cleanup is done using a class with the expectation that the
destructor will be called when the thread gets canceled by a cancel
signal. This seems like a big problem for all current MIPS kernels so
I was wondering if I'm missing something?

If this is correct, then it seems like the best solution would be to
add the VDSO eh_frame info to MIPS.

Thanks
Al Cooper
