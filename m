Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0FYRw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:52:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45218 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab0FYRw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cZRDsySW0dRtYS2+tKepU5ub03pkTxavtxeI0UXTSuvioxrb2jW5Aqaoe01UezTtwU
         zK8Q+AnCm6RQnUmNUK6tDyRffp6pvFCVLK7NeI0RTP1ysPrNTqqjj9mReYEC/surAx94
         DjnIP9gRBUQfTe5lV5mT032XOMJ5o9k8ZPpNs=
MIME-Version: 1.0
In-Reply-To: <1A529206-98C4-4A88-A2CA-18522D4D631D@dilger.ca>
References: <20100624131455.GA10441@laptop> <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca> 
	<20100625040156.GQ10441@laptop> <1A529206-98C4-4A88-A2CA-18522D4D631D@dilger.ca>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 25 Jun 2010 10:52:05 -0700
Message-ID: <AANLkTin__C1EOuTFJJ4UqAFsO5x_IOKLX11boRl7B194@mail.gmail.com>
Subject: Re: [rfc] new stat*fs-like syscall?
To: Andreas Dilger <adilger@dilger.ca>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 10:47, Andreas Dilger <adilger@dilger.ca> wrote:
> SUSv2 only defines the flags ST_RDONLY and ST_NOSUID, and this is also what is documented in the Linux/BSD/OSX statvfs(3) man page.  According to the Solaris statvfs(3) man page I found it additionally defines:
>
> ST_NOTRUNC   0x04    /* does not truncate file names longer than
>                        NAME_MAX */

glibc supports many more flags.  SuS of course has to restrict itself,
there are not that many flags which are portable and available on all
the platforms.  Look at /usr/include/bits/statvfs.h for what has to be
supported and the values to use.  If the values the kernel will use
differ I'd have to (unnecessarily) convert the values.  If some values
are missing/not supported I still would have to use /proc/mounts and
nothing is gained.
