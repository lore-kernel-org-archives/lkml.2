Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab1KJIWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:22:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61536 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KJIV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:21:58 -0500
MIME-Version: 1.0
In-Reply-To: <m3pqh0tnoi.fsf@blackfin.pond.sub.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<4EBB4A21.20707@codemonkey.ws>
	<alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
	<m3pqh0tnoi.fsf@blackfin.pond.sub.org>
Date: Thu, 10 Nov 2011 10:21:57 +0200
X-Google-Sender-Auth: xZWTfNdF7pCK-B_Z6bXDg_66FqE
Message-ID: <CAOJsxLEzk_kXrG23fo-A85zoeKyS4_1pJibG=gvQFcTREsPOjQ@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Pekka Enberg <penberg@kernel.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 9:57 AM, Markus Armbruster <armbru@redhat.com> wrote:
>>> 3) The block probing code replicates a well known CVE from three
>>> years ago[1]. Using kvm-tool, a malicious guest could write the
>>> qcow2 signature to the zero sector and use that to attack the host.
>>
>> We don't support QCOW2 snapshots so I don't see how the "arbitrary
>> file" thing can happen.
>
> You don't need snapshots for the hole.
>
> Start with a clean read/write raw image.  Probing declares it raw.
> Guest writes QCOW signature to it, with a backing file of its choice.
>
> Restart with the same image.  Probing declares it QCOW2.  Guest can read
> the backing file.  Oops.
>
> Probing images works when all image types can be probed reliably, and
> the guest can't mess with the probing.  Requires distinctive signatures
> the guest can't change.  Raw images spoil it.

We don't support that "backing file" thing either. ;-)

On Thu, Nov 10, 2011 at 9:57 AM, Markus Armbruster <armbru@redhat.com> wrote:
>> It's pretty sad though that we're replicating a known security issue :-/
>
> Maybe I'm wrong, but I got the impression you've been replicating quite
> a few of QEMU's early mistakes.
>
> I hope you can create something better than QEMU, I really, really do.
> But to successfully build a second system, you need to learn the right
> lessons from the first system.  Are you sure you do?

We do but it's a fair question if we're doing it enough. I don't have
a simple answer to that.

                        Pekka
