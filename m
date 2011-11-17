Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1KQO5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:57:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39690 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab1KQO5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:57:08 -0500
Message-ID: <4EC520AE.3070409@zytor.com>
Date: Thu, 17 Nov 2011 06:56:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: wangyanqing <Udknight@gmail.com>, torvalds@linux-foundation.org,
        castet.matthieu@free.fr, akpm@linux-foundation.org, x86@kernel.org,
        spock@gentoo.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: remove NX from video bios area
References: <20111117082624.GA4136@udknight.homenetwork>
In-Reply-To: <20111117082624.GA4136@udknight.homenetwork>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 12:26 AM, wangyanqing wrote:
>  
> +/*we hope this the right video bios range*/
> +#define VIDEO_BIOS_BEGIN	0x000c0000
> +#define VIDEO_BIOS_END		0x000c7fff
> +
>  #define BIOS_ROM_BASE		0xffe00000
>  #define BIOS_ROM_END		0xffffffff

Ick.  This feels increasingly hacky, especially since the above is known
to not be the video BIOS range on a lot of reasons.

There is something much more fundamentally wrong here, including why X
permission is needed for uvesafb at all.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

