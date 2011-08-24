Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1HXJTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:19:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43574 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1HXJTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:19:18 -0400
Message-ID: <4E54C210.1030204@kernel.org>
Date: Wed, 24 Aug 2011 12:19:12 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: linux next: Native Linux KVM tool inclusion request
References: <1314044960.3668.9.camel@lappy> <20110823003925.GA30253@infradead.org> <CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com> <4E54B6E2.2030203@redhat.com>
In-Reply-To: <4E54B6E2.2030203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/11 11:31 AM, Avi Kivity wrote:
> On 08/23/2011 08:08 AM, Pekka Enberg wrote:
>> As for changes, we've implemented rootfs over 9p with "kvm run"
>> booting to host filesystem "/bin/sh" by default.
>
> Isn't this dangerous?  Users expect virtualization to land them in 
> sandbox, but here an rm -rf / in the guest will happily junk the host 
> filesystem.

Not really because I never run the tool as root. However, you're right that
we should not default to /bin/sh if you're root.

>> It still needs some
>> work and we hope to enable networking too. We also have patches to use
>> overlayfs so that the guest is able to use host filesystem in
>> copy-on-write manner.
>
> Still dangerous (but just to the guest), since it's not a true 
> snapshot.  If the host filesystem changes underneath the guest, it 
> will see partial and incoherent updates.  Copy-on-write only works if 
> the host filesystem doesn't change.

That's a generic problem with overlayfs based solutions, isn't it? We're 
planning
to use copy-on-write only on files that aren't supposed to change that 
often -
like /usr and /lib. I suppose we should force shared files to be 
read-only in
the guest.

                                     Pekka
