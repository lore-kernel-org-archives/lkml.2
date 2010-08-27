Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0H0WJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:09:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41257 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0H0WJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=R9Lts4iu/EgvZTeP/ezB5+AD9r8Rp1ZT33wX52A8uUhWayijO6AQbUtL7TZaInnURF
         SfqPn1LtDikFASrTOyD9/hxpgl5EstIpW8tqIcESe0EZllppwnuGHtL0xfuRU1eF/JCu
         lYkfXmPRfCgxEmEnsBFLRg8BakBRsIC/NuZbQ=
MIME-Version: 1.0
In-Reply-To: <20100827101651.GC5348@loge.amd.com>
References: <20100827101651.GC5348@loge.amd.com>
Date: Fri, 27 Aug 2010 18:09:51 -0400
X-Google-Sender-Auth: GR1rzksfPAs1f1U8pmVSK9Y6cJc
Message-ID: <AANLkTinMCi=bxqJ+3WhNOM6AoaHLi_8WOUSi_wrzno5p@mail.gmail.com>
Subject: Re: [PATCH] bitops: Provide generic sign_extend function (moving it
 out from wireless code)
From: Bob Copeland <me@bobcopeland.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>, Zhu Yi <yi.zhu@intel.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 6:16 AM, Andreas Herrmann
<herrmann.der.user@googlemail.com> wrote:

> -static int sign_extend(int val, const int nbits)
> -static s32 sign_extend(u32 oper, int index)

Note these two are specified slightly differently, so return different
values with the same arguments.  The ath[59]k version takes the number
of bits (1-based) while the other one takes the position of the high
order bit (0-based).  I think the former is a little more natural but
it's a matter of taste.

Anyway I personally have no problem with merging them once the above
is fixed.  I wrote a similar patch when I wrote the ath5k version, but
never bothered to submit it.

-- 
Bob Copeland %% www.bobcopeland.com
