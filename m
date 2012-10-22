Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab2JVROG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:14:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47175 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2JVROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com>
References: <1350907434-2202-1-git-send-email-elezegarcia@gmail.com>
	<0000013a88ebfa65-af0fc24b-13fd-400f-b7fc-32230ca70620-000000@email.amazonses.com>
Date: Mon, 22 Oct 2012 14:14:03 -0300
Message-ID: <CALF0-+VqGrcjw16rNPH459YAj7dubQnruzV-zOzYn6feOtQ4tQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/slob: Mark zone page state to get slab usage at /proc/meminfo
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

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

... and I have a question about this.

SLUB handles large kmalloc allocations falling back
to page-size allocations (kmalloc_large, etc).
This path doesn't touch NR_SLAB_XXRECLAIMABLE zone item state.

Without fully understanding it, I've decided to implement the same
behavior for SLOB,
leaving page-size allocations unaccounted on /proc/meminfo.

Is this expected / wanted ?

SLAB, on the other side, handles every allocation through some slab cache,
so it always set the zone state.

Thanks!

    Ezequiel
