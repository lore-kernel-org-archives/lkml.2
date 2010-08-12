Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061Ab0HLWXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:23:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54157 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760987Ab0HLWX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qwZtW04BwTle/wIMkMjLenn80SLSkpnWFsBJTN/tDg30CqEQjulq7nTS+TClPoOXro
         +iS/qcJsGYDX7lBsG3dNm7NgFb3PJ9+QeA43REr1bRIzXQe+bzyguzMECen+/V1YyJE4
         RhrvnVtjqhRGlwxddTaBhPrBVzQpOJc13Wkro=
MIME-Version: 1.0
In-Reply-To: <AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
	<AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
	<AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
	<AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
Date: Thu, 12 Aug 2010 15:23:28 -0700
Message-ID: <AANLkTin6cHofTWkAysi_hojxaYUJtXg44_F0AyffMy5k@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 9:24 AM, Tony Luck <tony.luck@intel.com> wrote:
> Yes it does. Please pull from
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release

I spoke too soon. Life is much better (boots with no issues). But when
using this
kernel to rebuild all my different configs, it locked up on the third
"make -j32".
That is to say that the build stopped making progress. The system is still alive
and can run other things.

top(1) shows few processes consuming cpu time. There's a pile of
defunct processes
and one of the "make" processes is stuck in "D" wait state.

I'm going to try the current kernel with the 424acaae reverted (and
with the ia64 rwsem.h
reverted too) to check whether this is still the same root cause - or
whether I need to
look for some other problem.

-Tony
