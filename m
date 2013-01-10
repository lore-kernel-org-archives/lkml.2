Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3AJNPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:15:18 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:57461 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3AJNPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:15:16 -0500
MIME-Version: 1.0
In-Reply-To: <50EEBC7C.70508@redhat.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
	<20130108173119.5e59fac2@annuminas.surriel.com>
	<CANN689H1eb_h-eX3wiEMczrA9hrX7C9zgwWzg0N7w_UcHHA2MA@mail.gmail.com>
	<50EEBC7C.70508@redhat.com>
Date: Thu, 10 Jan 2013 05:15:15 -0800
Message-ID: <CANN689F64smbcDmQPBJcQ4ZjxTWvLk79Qrc9vVVUHs4VfSAGXQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86,smp: keep spinlock delay values per hashed
 spinlock address
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 5:05 AM, Rik van Riel <riel@redhat.com> wrote:
> Eric,
>
> with just patches 1-3, can you still reproduce the
> regression on your system?
>
> In other words, could we get away with dropping the
> complexity of patch 4, or do we still need it?

To be clear, I must say that I'm not opposing patch 4 per se. I think
we should not rely on it to avoid regressions, as patch 3 needs to be
robust enough to do that on its own. However, it may very well be that
having different constants for each lock (or for each hash bucket as a
proxy) helps - if lock B has a consistently longer hold time than lock
A, having them in separate hash buckets will allow us to use optimal
tunings for both, but if they collide or if we don't have a hash
table, we'll use a delay that is close to A's value for both, which is
safe (shouldn't introduce regressions) but not optimal.

In other words, I really don't want us to depend on the hash table for
robustness but I think it's fine to have it for extra performance (as
it's actually very short)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
