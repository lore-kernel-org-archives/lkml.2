Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab1FWRzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:55:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43580 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab1FWRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:55:37 -0400
Date: Thu, 23 Jun 2011 18:55:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Alex Elder <aelder@sgi.com>,
        xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
Message-ID: <20110623175533.GK11521@ZenIV.linux.org.uk>
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
 <m2boxocvb5.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2boxocvb5.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:27:26AM -0700, Andi Kleen wrote:
> Maarten Lankhorst <m.b.lankhorst@gmail.com> writes:
> 
> > gcc with -Warray-bounds generates a false positive on this
> > since xfs defines the struct with u8 name[1]; to be able to
> > add a tag at the end.
> 
> A better way would be to define it as name[0]. Then the compiler
> would know it's a VLA. You may need to check noone relies on
> the one byte though.

... and even better is to write in real C and have u8 name[]; in the
end of your structure.  That's the standard C99 for this kind of thing
(see 6.7.2.1p2, p16).  Zero-sized array is a gccism predating standard
flexible array members and since the standard syntax is accepted by
any gcc version that might be recent enough to build the kernel...
