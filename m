Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2EESz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:55:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46889 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2EESzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
 <20120505115851.1fecbe50@pyramind.ukuu.org.uk> <Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 May 2012 11:55:03 -0700
X-Google-Sender-Auth: V7IceHvtu8cq3MlPAgpm00wcLnw
Message-ID: <CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 11:53 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> What NO_IRQ problem do you mean? There is
> #define NO_IRQ          (-1)
> in arch/parisc/include/asm/irq.h.

That's the one he means.

Switching it to zero and testing that things still work would be appreciated.

Much code already knows that NO_IRQ is supposed to be zero, and
there's tons of drivers that just do the (correct!) "if (!dev->irq)"
kind of thing.

Any architecture that has a non-zero NO_IRQ is basically broken.
Always has been.

                    Linus
