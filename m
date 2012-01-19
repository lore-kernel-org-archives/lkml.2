Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2ASQSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:18:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60927 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab2ASQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:17:56 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx7CV8wpDLfCr-pVVRxRyYgd2QdRXJSmp+UgrjSHyB1eA@mail.gmail.com>
References: <7f1e961d.f528.134efaf8348.Coremail.dragonylffly@163.com>
	<CA+55aFx7CV8wpDLfCr-pVVRxRyYgd2QdRXJSmp+UgrjSHyB1eA@mail.gmail.com>
Date: Thu, 19 Jan 2012 10:17:55 -0600
X-Google-Sender-Auth: WE_oq-XR1MMgMsWkpNMFmBi0B2w
Message-ID: <CANT6BaO418KViOgCj11qCKi8keZ+tqbEAkCvBFvwNF4EtUziEA@mail.gmail.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
From: Dustin Kirkland <dustin.kirkland@gazzang.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dragonylffly <dragonylffly@163.com>, tyhicks@canonical.com,
        john.johansen@canonical.com, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> There are *two* cases where we do that "total_remaining_bytes"
> calculation. The same bug seems to exist both in ecryptfs_read() and
> ecryptfs_write().
>
> Possibly only the ecryptfs_write() one leads to an endless loop, but
> the read one looks suspicious too.
>
> Also, what protects things against this just being one nasty DoS
> attack - even if the code is fixed to not be an endless loop, it looks
> like a trivial "truncate()" can be used to generate a *practically*
> infinite write stream. At the very least, this should be KILLABLE. Or
> did I mis-read the code?
>
> Tyler, Dustin, others - comments? This looks nasty.

Definitely nasty, Linus.  This is almost certainly the source of a
long-standing bug [1] we've had with tor-downloads into eCryptfs
mounts hanging the OS.  Tor clients truncate a file at the start of
the download large enough to handle the eventual result.

Glad to see this finally triaged and a fix in the works, Li Wang and
Yunchuan Wen.  Thanks for that.

[1] https://bugs.launchpad.net/ecryptfs/+bug/431975

-- 
:-Dustin

Dustin Kirkland
Chief Architect
Gazzang, Inc.
www.gazzang.com
