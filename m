Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1KHRXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:23:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1KHRW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:22:58 -0500
Message-ID: <4EB96829.1010709@suse.de>
Date: Tue, 08 Nov 2011 18:34:33 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <4EB93FA4.8020800@redhat.com> <20111108145257.GA10846@infradead.org> <4EB94340.5040205@redhat.com> <20111108145945.GA17842@infradead.org>
In-Reply-To: <20111108145945.GA17842@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 03:59 PM, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 04:57:04PM +0200, Avi Kivity wrote:
>>> Running qemu -snapshot on the actual root block device is the only
>>> safe way to reuse the host installation, although it gets a bit
>>> complicated if people have multiple devices mounted into the namespace.
>> How is -snapshot any different?  If the host writes a block after the
>> guest has been launched, but before that block was cowed, then the guest
>> will see the new block.
> Right, thinko - qemu's snapshots are fairly useless due to sitting
> ontop of the file to be modified.
>
>> It could work with a btrfs snapshot, but not everyone uses that.
> Or LVM snapshot.  Either way, just reusing the root fs without care
> is a dumb idea, and I really don't want any tool or script that
> encurages such braindead behaviour in the kernel tree.

Heh, yeah, the intent was obviously to have a separate rootfs tree 
somewhere in a directory. But that's not available at first when running 
this, so I figured for a simple "get me rolling" FAQ directing the 
guest's rootfs to / at least gets you somewhere (especially when run as 
user with init=/bin/bash).

Alex

