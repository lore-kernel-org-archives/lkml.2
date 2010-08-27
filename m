Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab0H0K2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:28:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56281 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0H0K2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:28:03 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>, Zhu Yi <yi.zhu@intel.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] bitops: Provide generic sign_extend function (moving it out from wireless code)
References: <20100827101651.GC5348@loge.amd.com>
Date: Fri, 27 Aug 2010 12:27:53 +0200
In-Reply-To: <20100827101651.GC5348@loge.amd.com> (Andreas Herrmann's message
	of "Fri, 27 Aug 2010 12:16:51 +0200")
Message-ID: <87k4ncic46.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann <herrmann.der.user@googlemail.com> writes:
>  
> +/**
> + * sign_extend - Sign extend a value using specified bit as sign-bit
> + * @value: value to sign extend
> + * @index: 0 based bit index (0<=index<32) to sign bit
> + */
> +static inline __s32 sign_extend(__u32 value, int index)
> +{
> +	__u8 shift = 31 - index;
> +	return (__s32)(value << shift) >> shift;
> +}

If it only handles 32bit please call it sign_extend32

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
