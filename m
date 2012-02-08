Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab2BHQ6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:58:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48149 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab2BHQ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:58:11 -0500
Message-ID: <4F32A98F.7030400@zytor.com>
Date: Wed, 08 Feb 2012 08:57:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
References: <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com> <8328.1328703626@redhat.com>
In-Reply-To: <8328.1328703626@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 04:20 AM, David Howells wrote:
> H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> However, they are nothing but standard (nonatomic) bit operations, and
>> we already have optimized versions of bit operations in the kernel.
>> We can't include <linux/bitops.h> in <asm/posix_types.h> but we can
>> move the definitions to <linux/time.h> and define them there in terms
>> of standard kernel bitops.
> 
> Why linux/time.h?  Why not linux/poll.h?  That would seem a more appropriate
> place for them.
> 
> David

If you look in the file a few lines below the patch, the reason should
be obvious.

Anyway, select() paraphernalia goes in <sys/time.h> (as opposed to
<time.h>), poll() paraphernalia goes in <sys/poll.h>, and the linux/*
files mimics that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


