Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0JKQxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:53:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49378 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JKQxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kc3YhOhaVx86Tho+vOn53NdDJMmRbFncLcfydgDdnd60VfxH7yfTcKu796wxVqCpsk
         VH2m9pBuVULjJnHn3/etxHLWaixCyI67hAw5/mURCkeX3SkJr3F0k2OtC4sMPEWkf7iC
         AVqBbX6e4j2bjJgR8KiIB07W28+gG90d6URTk=
MIME-Version: 1.0
In-Reply-To: <987664A83D2D224EAE907B061CE93D530163EA9C09@orsmsx505.amr.corp.intel.com>
References: <1286560501-26843-1-git-send-email-andi@firstfloor.org>
	<987664A83D2D224EAE907B061CE93D530163EA9C09@orsmsx505.amr.corp.intel.com>
Date: Mon, 11 Oct 2010 09:53:22 -0700
Message-ID: <AANLkTin7_3_iwn2xf=wy9ho9GfCHw+eSTjv12z1ESWr5@mail.gmail.com>
Subject: Re: [PATCH] Define _addr_lsb in siginfo_t for mips and ia64
From: Tony Luck <tony.luck@gmail.com>
To: Andi Kleen <andi@firstfloor.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 11:13 AM, Luck, Tony <tony.luck@intel.com> wrote:
> ia64 has HAVE_ARCH_COPY_SIGINFO_TO_USER - so it doesn't see
> this build problem because the version of copy_siginfo_to_user()
> in kernel/signal.c isn't the one we use. So I don't think that
> we need this (unless someone has some plan to unify the
> ARCH specific version).

I take this back ... in next-20101011 the disease has spread:

fs/signalfd.c: In function ‘signalfd_copyinfo’:
fs/signalfd.c:109: error: ‘const struct <anonymous>’ has no member
named ‘_addr_lsb’
fs/signalfd.c:109: warning: type defaults to ‘int’ in declaration of ‘__pu_x’
fs/signalfd.c:109: error: ‘const struct <anonymous>’ has no member
named ‘_addr_lsb’

So today I have build problems :-(

A question about the naming/type of this new field. "lsb" sounds like
it might mean
"least significant byte (or perhaps bit)" ... why is the type "short"?

-Tony
