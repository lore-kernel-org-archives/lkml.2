Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2JXQmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:42:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57806 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2JXQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-28-git-send-email-koverstreet@google.com>
	<20121019203015.GS13370@google.com>
	<20121022153907.GC3401@redhat.com>
	<yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
Date: Wed, 24 Oct 2012 12:42:46 -0400
X-Google-Sender-Auth: EQ2uobe9IPoB7rSKEi_o_xMMR5w
Message-ID: <CAOS58YPFq_rt1Pw-v1XtX7-tnPGceXP5Chpp9JhkkMtnWnNQsg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
From: Tejun Heo <tj@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Kent Overstreet <koverstreet@google.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Wed, Oct 24, 2012 at 12:34 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:
>
> Vivek> Initially he had reordered the bio_pair fields but there were
> Vivek> couple of issues. We could not assume that there is no padding
> Vivek> between fields and secondly some of the initializtion of looked
> Vivek> plain ugly.
>
> Vivek> IMHO, introduction of bip_vec to fix this issue is small and
> Vivek> cleaner then reordering fields.
>
> I agree.

If Martin is happy with it, I'm not gonna push it but putting the
respective storage member after one containing vararray at the end is
a legit way to allocate the area statically. As long as the storage
field is marked as such and not accessed directly, it doesn't matter
whether there's padding inbetween or not. Anyways, let's push this one
to -stable then.

Thanks.

-- 
tejun
