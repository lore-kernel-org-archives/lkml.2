Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab1C3WdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:33:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756338Ab1C3WdJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <201103302355.38136.rjw@sisk.pl>
References: <201103292143.12777.rjw@sisk.pl> <201103302247.16339.rjw@sisk.pl>
 <AANLkTikoBbbq223q7+2kS_nLDi7XUtgT2hczu9P6nQCx@mail.gmail.com> <201103302355.38136.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 15:24:43 -0700
Message-ID: <AANLkTiksT50imm3yQJPrRTqp732=jNYqnNdyvGhGbyHQ@mail.gmail.com>
Subject: Re: [GIT PULL] Power management Kconfig modification for 2.6.39
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> That, in fact, is not necessary.  Moreover, it turns out that the patch size
> is not much different, because only a few subsystems use CONFIG_HIBERNATION
> directly.
>
> The patch below has only been slightly tested, in particular I'd like the Xen
> people to check if it works for them.

Ok, this seems to make much more sense. Just from a quick scan, the
places where you changed things to

  #ifdef CONFIG_HIBERNATE_CALLBACKS

really do seem to be about the freeze/thaw callbacks. So now the patch
looks more logical to me. And it obviously doesn't change the
user-visible questions.

Thank you,

            Linus
