Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0GLSLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:11:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38581 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab0GLSLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:11:01 -0400
Message-ID: <4C3B5A4A.4070107@zytor.com>
Date: Mon, 12 Jul 2010 11:09:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai.lu@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <20100712174420.GC5687@lenovo>
In-Reply-To: <20100712174420.GC5687@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 10:44 AM, Cyrill Gorcunov wrote:
> 
> Peter, while reviewing this patch I found another nit in
> context of early_param usage, so the patch is below. It's
> completely trivial. Actually I thought I've already fixed
> all early_param cases long ago but this one somehow sneaked ;)
> 
> Anyway, Yinghai, Peter,
> 
> I'm not sure but can't we use some boot_param "pad" field for
> "being copied" flag instead of new variable? There is a case
> when boot_param is used as __initdata and I'm not sure we clear
> this section explicitly.
> 

Actually, even better would be to simply use boot_params.hdr.version,
which will never be zero.

	-hpa
