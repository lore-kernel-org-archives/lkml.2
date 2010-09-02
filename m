Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0IBRZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:25:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61900 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0IBRZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=J27EPgFIKAHPE9osr2jczG0UWIS836cc1b8S6mcSBObrBsHv2LgMKylPTcGAFMDCzB
         /W3NVHCTQV6uScI3TtjTsyp/wa2YBohTgbrm0JQLibXLQk4WudT56m0R6XFYrwa1aklk
         mULhB2BXdiEfxiHpmIIJsVAxVyaJC/vxBUUpo=
MIME-Version: 1.0
In-Reply-To: <4C7FDCE4.1080703@kernel.org>
References: <1283446829-24050-1-git-send-email-namhyung@gmail.com> <4C7FDCE4.1080703@kernel.org>
From: Namhyung Kim <namhyung@gmail.com>
Date: Fri, 3 Sep 2010 02:25:22 +0900
Message-ID: <AANLkTi=Ema3mTkU7J7XKqmntA+VDJizhBuDHHnZtV_9K@mail.gmail.com>
Subject: Re: [PATCH] ida: fix up bitmap size calculation
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 3, 2010 at 02:20, Tejun Heo <tj@kernel.org> wrote:
> The -1 when calculating IDA_BITMAP_LONGS is intentional.  Please see
> below.
>
> struct ida_bitmap {
>        long                    nr_busy;
>        unsigned long           bitmap[IDA_BITMAP_LONGS];
> };
>
> With the -1, sizeof(struct ida_bitmap) becomes 128 bytes but if you
> remove the -1, it becomes 132 bytes.  Because ida_bitmap doesn't use
> dedicated slab (doesn't make sense as it's not a very hot data
> structure), with 132 bytes, it's gonna be allocated from 256 byte slot
> wasting ~50% of memory.  Adding a comment there to clarify why -1 is
> there would be nice tho.
>

Got it. :-) I'll prepare new patch with that comment, then.
Thank you for the explanation.

-- 
Regards,
Namhyung Kim
