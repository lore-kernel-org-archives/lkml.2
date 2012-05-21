Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2EUSiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:38:13 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:10249 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab2EUSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:38:11 -0400
Date: Mon, 21 May 2012 20:38:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20120521183807.GA6104@merkur.ravnborg.org>
References: <20120521.050300.1434374935904126254.davem@davemloft.net> <CA+55aFzag=LfduvHSmE34nEVYOk=MRhUMzK854+icLwthmz5Ng@mail.gmail.com> <20120521182400.GA6043@merkur.ravnborg.org> <CA+55aFymRE-_1qzCA_n3xYbMseQrZsjJWWX74S3jn5Qyf9Efjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFymRE-_1qzCA_n3xYbMseQrZsjJWWX74S3jn5Qyf9Efjw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:28:58AM -0700, Linus Torvalds wrote:
> On Mon, May 21, 2012 at 11:24 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > So the "if NET" part in the select is redundant but not strictly wrong.
> 
> It's not redundant.
> 
> Try doing a "make ARCH=sparc allnoconfig" without it. It will warn.
> 
> I didn't bother looking at *why* it warns, but all other architectures
> have the "if NET" part.

I see. This is because HAVE_BPF_JIT depends on NET, so kconfig
warns if you select HAVE_BPF_JIT without NET enabled.
The correct fix is obviously to move HAVE_BPF_JIT so it
does not depend on NET.

Sprinkling "if NET" all over is the wrong fix.

	Sam
