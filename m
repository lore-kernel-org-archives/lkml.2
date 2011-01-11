Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1AKQUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:20:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125Ab1AKQUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:20:13 -0500
MIME-Version: 1.0
In-Reply-To: <4D2C21FE.3000406@redhat.com>
References: <4D2ACFA7.6000502@redhat.com> <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
 <4D2C21FE.3000406@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 08:19:05 -0800
Message-ID: <AANLkTi=_WTXYGgb3G6eWAkSpfR_=pDC=w9feKtKK8zLV@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 1:25 AM, Avi Kivity <avi@redhat.com> wrote:
>
> What are your issues with the patch?

My issues are mainly two-fold:

 - I think "MINOR" is a totally idiotic and meaningless term. It has
no technical meaning. Why would IO be special? Is it because of
deadlock concerns with filesystem or block device layer locks? No. And
it clearly isn't about "sleeping", since a major fault can be
non-sleeping (think ramdisk, for example).

   Look at the other FAULT_FLAG_xyzzy flags. They have _hard_
technical reasons. There's no ambiguity. And we ALREADY HAVE the one
that says "return if it would need to wait", and it's called
FAULT_FLAG_ALLOW_RETRY.

The other issue is:

 - I wasn't aware of this, and clearly not enough other people were
either, or somebody would have told you that we already had people
working on the whole FAULT_FLAG_ALLOW_RETRY thing that is much fancier
and technically superior.

So it simply boils down to the fact that I don't think
FAULT_FLAG_MAJOR was a good idea. It's badly done, is a total and
utter hack, and I don't see why I should ever merge it.

                          Linus
