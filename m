Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2D0W5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:57:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab2D0W5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:57:09 -0400
Message-ID: <4F9B2420.5030806@zytor.com>
Date: Fri, 27 Apr 2012 15:56:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <20120427.151433.1007849975903946491.davem@davemloft.net> <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com> <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com> <4F9B050C.3000309@zytor.com> <CA+55aFz-1n=REkh9SzA1aEz5J_uGc=B_nKj+cP8J=PR6YSZD1w@mail.gmail.com>
In-Reply-To: <CA+55aFz-1n=REkh9SzA1aEz5J_uGc=B_nKj+cP8J=PR6YSZD1w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 03:42 PM, Linus Torvalds wrote:
> 
> Have you looked at the interface?
> 

Yes.  I designed and implemented the v1-3 versions of the interface.
v4-5 has kept the pipe, but at least v5 dropped the reading of the
header with the included length as a separate operation.

> The file descriptor is created in user space, and is defined to be a
> pipe. So both automount and systemd create a pipe, and then pass that
> pipe fd to the mount system call.
> 
> So it is not autofs that creates the file descriptor for the user.
> It's the other way around: the user creates (using "pipe()") the file
> descriptor, and passes it to autofs.

I would have used SOCK_SEQPACKET if it had existed today, and so if
there is going to be a change in the interface I would use it.

I guess, though, what you're saying is to change the semantic of the
existing pipe to return short reads on the receive end.  That won't work
since the daemon code is written to loop back and read more if it
doesn't fill the buffer, so it "swallows the comma."  Hence it's a new
interface no matter how you slice it.

	-hpa


