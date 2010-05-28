Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab0E1GKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:10:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:1854 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0E1GKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=R71mlm+cf1tfkJn05z4qjD9BMcwKwuotSDtYgz7K3J6P9iIdl78bJjGKrA0A54Lp0V
         UzooNRUPvCiSMABqU1vojayvCjdONb7GUB+B2HfNjXEYDguIDCubfexBU2iA55FcJaZy
         /T55aHIyQkpXAhQoz6ZbRa6W/q8KFSnL1SzIA=
Message-ID: <4BFF5E3B.5060305@gmail.com>
Date: Fri, 28 May 2010 08:10:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: JD <jd1008@gmail.com>
CC: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: udevd high cpu hogging in kernel-2.6.34   git8 to git-13
References: <4BFF565C.3080108@gmail.com> <4BFF59B5.70002@gmail.com> <4BFF5D6C.3010207@gmail.com>
In-Reply-To: <4BFF5D6C.3010207@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added lkml back to CC.

On 05/28/2010 08:06 AM, JD wrote:
> But here goes:
> I have seen this behaviour in all the git releases from git8
> to the current 2.6.34-git13
> 
> I have some of the analysis based on strace, and kernel stack
> trace.
> Instead of backing out the whole code for the new udevd, perhaps
> it (udevd) should sleep for some time before polling the same fd
> again.

So if you see in the strace output the poll to return immediately with
out fd being an anon_inode (check /proc/pid_of_udev/fd/), it is the
issue. AFAIK, it was not fixed upstream yet.

So could you try to revert a7cf4145b?

-- 
js
