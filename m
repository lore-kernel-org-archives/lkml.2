Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2ARQgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:36:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59773 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2ARQgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:36:47 -0500
Message-ID: <4F16F505.8040809@zytor.com>
Date: Wed, 18 Jan 2012 08:36:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        luca@luca-barbieri.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com>
In-Reply-To: <4F16E41B020000780006D7A5@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 06:24 AM, Jan Beulich wrote:
> The cmpxchg8b variants of "set" and "xchg" are really identical, and
> hence don't need to be repeated: %ebx and %ecx don't need to be copied
> into %eax and %edx respectively (this is only necessary when desiring
> to only read the stored value), and the LOCK prefix should also be used
> in "set" (other than the comment that is now being removed was saying,
> there is - to my knowledge - no *architectural* guarantee that aligned
> 64-bit writes would always be carried out atomically).

EWHAT?

It's atomic in the same way a MOV is atomic.

The CPU could, in fact, execute the locked version at all if the
unlocked version didn't behave like that.

Unless you have a specific instance where you think this might be
violated, please let me know.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

