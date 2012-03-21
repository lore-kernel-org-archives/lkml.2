Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2CUVsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:48:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61034 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2CUVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:48:08 -0400
Message-ID: <4F6A4C91.5040300@redhat.com>
Date: Wed, 21 Mar 2012 22:48:01 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] block: align start sector of a discard request
References: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/03/2012 18:12, Paolo Bonzini ha scritto:
> When a disk has a large discard_granularity, discards are not split with
> optimal alignment; the pessimization gets bigger as discard_granularity
> and max_discard_sectors become closer.
> 
> Take the limit case of discard_granularity == max_discard_sectors == 64.
> Then, if a request is submitted for 256 sectors 2..257 it will be split
> like this: 2..65, 66..129, 130..193, 194..257.  None of these requests
> is aligned, so in fact you might end up with no discarded logical blocks
> at all.  With this patch, the split will be 2..63, 64..127, 128..191,
> 192..255, 256..257.  The patches also take the discard_alignment into
> consideration.
> 
> Patch 1 adjusts the computation of the granularity-adjusted
> max_discard_sectors so that it prepares for the new code in patch 2,
> while patch 2 actually adjusts the split.
> 
> Paolo Bonzini (2):
>   block: tweak rounding of max_discard_sectors
>   block: split discard into aligned requests
> 
>  block/blk-lib.c    |   41 +++++++++++++++++++++++++++--------------
>  1 files changed, 27 insertions(+), 14 deletions(-)
> 

Ping?

Paolo
