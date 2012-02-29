Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2B2IN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:13:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab2B2IN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:13:26 -0500
Message-ID: <4F4DDE14.8050406@redhat.com>
Date: Wed, 29 Feb 2012 09:13:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] block: avoid false positive warnings on ioctl to partition
References: <1329464338-8351-1-git-send-email-pbonzini@redhat.com> <4F4B78CE.4010405@redhat.com> <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com>
In-Reply-To: <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/02/2012 01:14, Linus Torvalds ha scritto:
> So I'm still not convinced this is safe, and feel a bit worried about
> us possibly silently missing some things. That
> 
>    default:
>       return -ENOIOCTLCMD;
> 
> is what worries me.
> 
> Blocking the ones we *know* about and understand I'm perfectly fine
> with. And the SG_IO case looks fine. It's the possibly unknown users
> that still worry me.

I understand.

We do have a good grasp of what's happening.  We did get reports for
SG_IO, for false positives that would have returned -ENOTTY, and for
ioctls that need to be passed.  We couldn't expect anything better than
this, I think.

I checked in the source and all scsi_host-specific ioctls need
filtering.  Of course we might be missing something really obscure which
is rarely used in the wild.  But being 100% sure that nothing breaks is
impossible, unfortunately, so does it make sense to aim at 100%?  And it
should be extremely easy to bisect failures.  Even with all the
differences, it reminds me of the recent change to poll.

Paolo
