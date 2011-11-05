Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1KEBXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:23:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60283 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1KEBXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <1320179267.14825.107.camel@deneb.redhat.com>
References: <1320179267.14825.107.camel@deneb.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Nov 2011 18:23:10 -0700
X-Google-Sender-Auth: 9ghtJkyY50akcC-Q8T70PG2yqJE
Message-ID: <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 1:27 PM, Mark Salter <msalter@redhat.com> wrote:
>
> Please pull this port of Linux to the Texas Instruments C6X architecture.
> The patches have all been acked and available for some time in linux-net.

Ugh. So I finally was about to merge this, but wanted to check the
non-C6x files before I did.

And that seems broken. If I read that code correctly, your
ARCH_PFN_OFFSET thing is just insane, and thinking that "pfn_valid()"
has anything to do with PAGE_OFFSET is crazy.

PAGE_OFFSET is about *virtual* addresses. It has absolutely nothing to
do with pfn's that are the physical page number. virt_to_pfn() already
corrects for PAGE_OFFSET (that part of your patch looks fine), your
change to *also* do it in pfn_valid() looks entirely bogus to me.

I'm not pulling new architectures that look like they will break old
ones, and do odd things to generic files.

                       Linus
