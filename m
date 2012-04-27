Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2D0WnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:43:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44835 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2D0WnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <4F9B050C.3000309@zytor.com>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <4F9B050C.3000309@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 15:42:55 -0700
X-Google-Sender-Auth: CfG1YaPUU1SN7bGmawLlmrqbXJM
Message-ID: <CA+55aFz-1n=REkh9SzA1aEz5J_uGc=B_nKj+cP8J=PR6YSZD1w@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 1:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Why not just use the already existing SOCK_SEQPACKET sockets?

Have you looked at the interface?

The file descriptor is created in user space, and is defined to be a
pipe. So both automount and systemd create a pipe, and then pass that
pipe fd to the mount system call.

So it is not autofs that creates the file descriptor for the user.
It's the other way around: the user creates (using "pipe()") the file
descriptor, and passes it to autofs.

                        Linus
