Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2IJOGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:06:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60103 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab2IJOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:06:14 -0400
Message-ID: <504DF3BC.30708@zytor.com>
Date: Mon, 10 Sep 2012 07:05:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86/xor: improve XMM register spill/fill
References: <504DFB5B020000780009A327@nat28.tlf.novell.com>
In-Reply-To: <504DFB5B020000780009A327@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 05:38 AM, Jan Beulich wrote:
> +/*
> + * By forcing the alignment beyond the default of 16 bytes, we make the
> + * compiler guarantee the alignment. Passing -mincoming-stack-boundary=3
> + * (which would have been the better global alternative, as the kernel
> + * never guarantees better stack alignment) isn't permitted on x86-64.
> + */

The very latest gcc should handle it, and in fact we compile with 
-mstack-alignment=3 if gcc accepts it (if it is not yet upstream it will 
be soon.)  This affects the validity of this patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

