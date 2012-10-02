Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2JBRn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:43:27 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:55383 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2JBRnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:43:24 -0400
Date: Tue, 2 Oct 2012 10:43:23 -0700
From: Zach Brown <zab@zabbo.net>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121002174323.GE14533@lenny.home.zabbo.net>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
 <20121001234439.GC14533@lenny.home.zabbo.net>
 <20121002002216.GI26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002002216.GI26488@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The generic code wouldn't know about any user pointers inside
> attributes, so it'd have to be downstream consumers. Hopefully there
> won't be many attributes with user pointers in them (I don't expect
> there to be), so we won't have too much of this messyness.

I really don't like this.  We should have learned this lesson with ioctl
structs that are nested pointers.

What about security bits that are trying to determine if attributes are
OK?

What about contexts that can't easily deal with userspace pointers?  We
tend to copy into relatively more accessible kernel memory as early as
possible.

What about fuse trying to extend this interface out to their fs clients?
Look at the horrible mess it implements to bounce nested ioctl data
parsing between the kernel's user pointer copying and the fuse client's
parsing of that copied data.

Let's not do this again, please.  I think it's a fallacy to claim that
the interface can be opaque to high levels and only parsed by lower
levels.  The interface should be explicit and fully specified on entry
so that all levels have trivial access to it.

- z
