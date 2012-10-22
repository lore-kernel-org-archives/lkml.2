Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2JVOui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:50:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64235 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2JVOuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com>
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com>
	<0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com>
Date: Mon, 22 Oct 2012 11:50:36 -0300
Message-ID: <CALF0-+X2GnTKykYT3pwDHZV-8-qoHQZdBaSscfrOei48ce-HWg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at /proc/meminfo
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:41 AM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 22 Oct 2012, Ezequiel Garcia wrote:
>
>> On page allocations, SLAB and SLUB modify zone page state counters
>> NR_SLAB_UNRECLAIMABLE or NR_SLAB_RECLAIMABLE.
>> This allows to obtain slab usage information at /proc/meminfo.
>>
>> Without this patch, /proc/meminfo will show zero Slab usage for SLOB.
>>
>> Since SLOB discards SLAB_RECLAIM_ACCOUNT flag, we always use
>> NR_SLAB_UNRECLAIMABLE zone state item.
>
> Hmmm... that is unfortunate. The NR_SLAB_RECLAIMABLE stat is used by
> reclaim to make decisions on when to reclaim inodes and dentries.
>
> Could you fix that to properly account the reclaimable/unreclaimable
> pages?

Sure. Does everyone agree on this?

My concern is:

1. SLOB is minimal, designed to have minimal footprint, and I'd like
to keep it that way. Of course, perhaps the change will add just a few bytes.

2. Since no SLOB user has ever complained on this...
How will this affect SLOB workings?
(I'm adding the uclinux guys, so at least they're aware of this)

    Ezequiel
