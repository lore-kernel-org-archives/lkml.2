Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1I3G7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:59:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1I3G7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:59:42 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz8AbSOZFp-nnvTTFkH5p1vgHfnu9KjsEKwUUOJH1WyUA@mail.gmail.com>
References: <1FB729E1-8CAA-4EEF-ABA4-200471843503@andrew.cmu.edu>
	<CA+55aFz8AbSOZFp-nnvTTFkH5p1vgHfnu9KjsEKwUUOJH1WyUA@mail.gmail.com>
Date: Fri, 30 Sep 2011 09:59:41 +0300
X-Google-Sender-Auth: NxtDq31LNm2MZbfW1vUA4wNTWS0
Message-ID: <CAOJsxLEzFKHkxSUh7jwQRmudtYzBRLFo3VdJpVjNOEgSCh3ehg@mail.gmail.com>
Subject: Re: [PATCH] kernel/groups.c: Minor bugfix for overflow in binary search
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Zimmerman <jzimmerm@andrew.cmu.edu>, akpm@linux-foundation.org,
        serge.hallyn@canonical.com, ebiederm@xmission.com, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 9:39 PM, Josh Zimmerman <jzimmerm@andrew.cmu.edu> wrote:
>> Fixed possible unsigned int overflow bug. (2 + 2^(32) - 1)/2 results in overflow; 2 + (2^(32)-1-2)/2 does not.

On Fri, Sep 30, 2011 at 8:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> We can't have that many groups anyway, so the overflow is pretty theoretical.
>
> The max should be NGROUPS_MAX, afaik (65536) and other places have
> lower limits (ie sunrpc/nfs). And if some place doesn't limit it
> correctly, we have bigger problems than this (the whole allocation and
> CPU use issues)

The code site could be converted to lib/bsearch.c::bsearch(), AFAICT. That'd
take care of the theoretical overflow too.

                        Pekka
