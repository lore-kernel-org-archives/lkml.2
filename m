Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1LRWOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:14:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1LRWOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:14:35 -0500
MIME-Version: 1.0
In-Reply-To: <dfbb748b-b9de-4390-bb8d-138fc4c5734f@email.android.com>
References: <20111217092935.2c2e075e@jbarnes-desktop> <CAE9FiQWueS=9aSAH4fLz=EpE=A_WanKU6pbfnR2a4gsymWjnDA@mail.gmail.com>
 <dfbb748b-b9de-4390-bb8d-138fc4c5734f@email.android.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Dec 2011 14:14:13 -0800
X-Google-Sender-Auth: fKFxY5Ddn12OmjtKfGzAKkVLGgs
Message-ID: <CA+55aFz7j8ipEn7e0dGnrG4dskyRiBOx0-ExAx3qnH_cR5mLQw@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 9:52 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Crap, and after you guys spent so long coming up with a clean version.
>
> Linus, can you just apply this one on top? I think it's the one Yinghai and Ram agreed to.

Ok, applied, but I have to say that I hate it.

Why don't we just move the stupid iov indexes to the end, and then
ignore them by not counting through them in
__pci_enable_device_flags()? So the regular PCI code would always walk
through the resources 0 .. PCI_BRIDGE_RESOURCES_END or something. And
then the magic IOV code could look at its own ones that the generic
code apparently doesn't even want to know about.

Hmm?

But as mentioned, in the meantime I applied this.

                Linus
