Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0CVGLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:11:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54649 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab0CVGLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:11:38 -0400
Message-ID: <4BA709AC.6070902@kernel.org>
Date: Sun, 21 Mar 2010 23:09:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>	 <1269155601-18247-7-git-send-email-yinghai@kernel.org>	 <1269225435.8599.70.camel@pasglop>  <4BA6EA62.1030603@kernel.org> <1269234723.8599.76.camel@pasglop>
In-Reply-To: <1269234723.8599.76.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 10:12 PM, Benjamin Herrenschmidt wrote:
> It -may- well be that adapting x86 to lmb isn't a practical approach,
> but if that was the case, then please justify why with precise technical
> reasons, which we can discuss then in details and make a decision based
> on that.

1. lmb is merging region when you add one new reserved region. 
early_res doesn't do that merge. so later it could figure wrong freeing.
<recently add free_early_partial, for per cpu setup only>
2. mem type in e820 map has more than RAM, it include RAM, reserved, ACPI, acpi nvs, and type 9?, and KERN_RESERVED...
3. early res, every range has one name tag.
4. early_res is array based, and it could auto double the array size and copy the old one to new one. and first entry in new array is for array itself.

if want x86 to use lmb, the e820 map and the lmb.memory are duplicated.
also need to have lmb.memory to support more type, otherwise still need to go back to check e820 about e820 reserved etc.


Thanks

Yinghai
