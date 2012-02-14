Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2BNTSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:18:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974Ab2BNTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:18:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+8MBb+rMJqJAyDnnkB=x794F3MAQJfwTi29=4oN4-6=g5uDFw@mail.gmail.com>
References: <CA+8MBb+rMJqJAyDnnkB=x794F3MAQJfwTi29=4oN4-6=g5uDFw@mail.gmail.com> <4F32A98F.7030400@zytor.com> <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com> <8328.1328703626@redhat.com> <16325.1328736262@redhat.com> <4F32E98F.2090909@zytor.com>
To: Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
Date: Tue, 14 Feb 2012 19:18:34 +0000
Message-ID: <30935.1329247114@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck <tony.luck@intel.com> wrote:

> Adding a #include <linux/string.h> to include/linux/time.h fixes them for me.

Which is one of the reasons I'd rather not see these things cropping up in
linux/time.h.  Either put them in linux/select.h (mirroring userspace) or
stick them in linux/poll.h with the rest of the polling paraphernalia.

__FD_SET() and co aren't exported to userspace anyway, as I understand it, so
it shouldn't hurt to bung them in linux/poll.h, and if they are exported to
userspace, they should stay in posix_types.h, shouldn't they?

To support this, at least three #includes will have to be added to
linux/time.h: linux/posix_types.h (which is fair enough), linux/bitops.h and
linux/string.h.

David
