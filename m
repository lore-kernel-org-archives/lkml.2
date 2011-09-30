Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1I3Foj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:44:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52509 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1I3Foh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <1FB729E1-8CAA-4EEF-ABA4-200471843503@andrew.cmu.edu>
References: <1FB729E1-8CAA-4EEF-ABA4-200471843503@andrew.cmu.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Sep 2011 22:44:16 -0700
X-Google-Sender-Auth: TzUh8MyevGZ-GQwWRI4gI6ykgqc
Message-ID: <CA+55aFz8AbSOZFp-nnvTTFkH5p1vgHfnu9KjsEKwUUOJH1WyUA@mail.gmail.com>
Subject: Re: [PATCH] kernel/groups.c: Minor bugfix for overflow in binary search
To: Josh Zimmerman <jzimmerm@andrew.cmu.edu>
Cc: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        ebiederm@xmission.com, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 9:39 PM, Josh Zimmerman <jzimmerm@andrew.cmu.edu> wrote:
>
> Fixed possible unsigned int overflow bug. (2 + 2^(32) - 1)/2 results in overflow; 2 + (2^(32)-1-2)/2 does not.

We can't have that many groups anyway, so the overflow is pretty theoretical.

The max should be NGROUPS_MAX, afaik (65536) and other places have
lower limits (ie sunrpc/nfs). And if some place doesn't limit it
correctly, we have bigger problems than this (the whole allocation and
CPU use issues)

            Linus
