Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1HXOTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:19:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58476 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1HXOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:19:49 -0400
MIME-Version: 1.0
In-Reply-To: <CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
	<CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
Date: Wed, 24 Aug 2011 17:19:48 +0300
Message-ID: <CACVxJT93c+tYryWGPdw6LM9X+3b_QT78B0D9JwksksvN0akBkQ@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Colin Walters <walters@verbum.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 4:15 PM, Colin Walters <walters@verbum.org> wrote:
> Seems pretty clear to me though it's a bug in the apps that are using
> '==' instead of .startswith().

This doesn't count under "no userspace breakage" doctrine.
Or rather, it shouldn't.

valgrind _compilation_ was broken by 3.0:
11 	*valgrind-3.6.1-r1 (09 Jun 2011)
12 	
13 	09 Jun 2011; Anthony G. Basile <blueness@gentoo.org>
14 	+valgrind-3.6.1-r1.ebuild, +files/valgrind-3.6.1-linux-3.patch:
15 	Fixed to build against linux-3.x, bug #370857

Was this fixed? Yes.
Will this break one more time? Of course!

         case "${kernel}" in
-             2.6.*)
+             2.6.*|3.*)
         	    AC_MSG_RESULT([2.6 family (${kernel})])
