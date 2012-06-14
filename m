Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2FNJCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2FNJCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:02:07 -0400
Message-ID: <4FD9A88A.8040701@redhat.com>
Date: Thu, 14 Jun 2012 11:02:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] msync: start async writeout when MS_ASYNC
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com> <1338497035-13014-3-git-send-email-pbonzini@redhat.com> <20120613142949.734818a8.akpm@linux-foundation.org>
In-Reply-To: <20120613142949.734818a8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/06/2012 23:29, Andrew Morton ha scritto:
> > If the application does not want to start I/O, it can simply call msync
> > with flags equal to MS_INVALIDATE.  This one remains a no-op, as it should
> > be on a reasonable implementation.
> 
> Means that people will find that their msync(MS_ASYNC) call will newly
> start IO.  This may well be undesirable for some.

If they knew it was a no-op, and relying on it, they might as well not
have called it at all and save a syscall.

> Also, it hardwires into the kernel behaviour which userspace itself
> could have initiated, with sync_file_range().  ie: reduced flexibility.

No, it hardwires into the kernel behaviour which is mentioned in the
spec.   Strictly speaking it is correct that an asynchronous operation
is never done (the two are indistinguishable), but still this patch
improves the fidelity to the specification and in a portable manner.

Paolo
