Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2BIUmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:42:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52158 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2BIUmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:42:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120209202938.GA14342@linux.intel.com>
References: <20120209202938.GA14342@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 12:42:00 -0800
X-Google-Sender-Auth: -DzExeXICnvF5fS7NniqbzJ9cCk
Message-ID: <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Doug Nelson <doug.nelson@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 12:29 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
>
> Commit 0bfc96cb77 adds this printk that triggers tens of thousands of
> times during a run of "a well-known database benchmark".  0x2285 is SG_IO.
> I'm not sure why scsi_id feels that it needs to repeatedly send a SCSI
> INQUIRY to a partition, but there we are.

So is it doing this as root (in which case we end up allowing it) or
as a normal user (in which case we end up disallowing it)?

And does it all work well apart from the printk? Because the printk
itself is scheduled to be removed, it's only there to hear about users
that may be doing crazy things that got disallowed by the patches in
question?

                    Linus
