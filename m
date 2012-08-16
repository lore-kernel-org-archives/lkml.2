Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2HPKkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:40:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57772 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2HPKko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:40:44 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: sedat.dilek@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com
Subject: Re: [PATCH 08/13] fs: limit filesystem stacking depth
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-9-git-send-email-miklos@szeredi.hu>
	<CA+icZUX32x5qiyxhAakxvo0Y4ypEA=DiurP5WCxbYmFi07+O4A@mail.gmail.com>
Date: Thu, 16 Aug 2012 12:42:03 +0200
In-Reply-To: <CA+icZUX32x5qiyxhAakxvo0Y4ypEA=DiurP5WCxbYmFi07+O4A@mail.gmail.com>
	(Sedat Dilek's message of "Thu, 16 Aug 2012 10:02:11 +0200")
Message-ID: <87sjbnce4k.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Wed, Aug 15, 2012 at 5:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Add a simple read-only counter to super_block that indicates deep this
>> is in the stack of filesystems.  Previously ecryptfs was the only
>> stackable filesystem and it explicitly disallowed multiple layers of
>> itself.
>>
>> Overlayfs, however, can be stacked recursively and also may be stacked
>> on top of ecryptfs or vice versa.
>>
>> To limit the kernel stack usage we must limit the depth of the
>> filesystem stack.  Initially the limit is set to 2.
>>
>
> Hi,
>
> I have tested OverlayFS for a long time with "fs-stack-depth=3".
> The original OverlayFS test-case script  from Jordi was slightly
> modified (see "testcase-ovl-v3.sh").
> I have sent my test-results to Andy and Jordi (tested with the
> patchset from Andy against Linux-v3.4 [1] with Ext4-FS).
> The attached test-case script *requires* "fs-stack-depth=3" to run
> properly (patch attached).
>
> So, I have 2 questions:
>
> [1] FS-stack-limitation
>
> Is a "fs-stack-depth>=2" (like "3") critical?
> Is your setting to "2" just a defensive (and initial) one?
> Can you explain your choice a bit more as ecryptFS is involved in this
> limitation, too.

If directly stacking filesystems like this on top of each other
(ecryptfs is currently the only filesystem that does this in mainline)
then the call chain can get too long and the kernel stack overflow.

Yes, setting it to 2 is defensive, it would need more stack depth
analysis to see what an acceptable number would be.


> [2] Test-Case/Use-Case scripts
>
> It would be *very very very* helpful if you could provide or even ship
> in the Linux-kernel a test-case/use-case script, Thanks!

Sure, I could add Andy's test script under the tools/ directory.  But I
don't understand why exactly it needs the stacking depth to be
increased.

Thanks,
Miklos
