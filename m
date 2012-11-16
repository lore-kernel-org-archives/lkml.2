Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2KPAqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:46:32 -0500
Received: from smtp2.Stanford.EDU ([171.67.219.82]:40353 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083Ab2KPAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:46:30 -0500
Message-ID: <50A58CE1.3000000@ccrma.stanford.edu>
Date: Thu, 15 Nov 2012 16:46:25 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.6-rt17
References: <alpine.LFD.2.02.1211122223300.10000@ionos> <50A3F75D.8090105@localhost> <alpine.LFD.2.02.1211151901300.2701@ionos>
In-Reply-To: <alpine.LFD.2.02.1211151901300.2701@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 10:11 AM, Thomas Gleixner wrote:
> On Wed, 14 Nov 2012, Fernando Lopez-Lezcano wrote:
>
>> On 11/12/2012 01:28 PM, Thomas Gleixner wrote:
>>> Dear RT Folks,
>>>
>>> I'm pleased to announce the 3.6.6-rt17 release. 3.6.6-rt16 is just a
>>> not announced update release to 3.6.6.
>>
>> Got this:
>>
>> ----
>> net/nfc/llcp/llcp.c: In function 'nfc_llcp_register_device':
>> net/nfc/llcp/llcp.c:1185:24: error: expected expression before '{' token
>> net/nfc/llcp/llcp.c:1186:35: error: expected expression before '{' token
>> ----
>>
>> when building with CONFIG_NFC / CONFIG_NFS_LLCP (builds fine when those are
>> not set)
>
> Grrr. Damned ignorants.
>
> Does that fix it for you ?

Yes, thanks! I had to tweak the patch but it does make the whole thing 
compile.
-- Fernando


> ------------>
>
> Subject: nfc: Use proper lock init functions
> From: Thomas Gleixner<tglx@linutronix.de>
> Date: Thu, 15 Nov 2012 19:03:20 +0100
>
> Grmbl. Why insist people on using static initializers if there are
> proper init functions? Just because they can?
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> ---
>   net/nfc/llcp/llcp.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-stable/net/nfc/llcp/llcp.c
> ===================================================================
> --- linux-stable.orig/net/nfc/llcp/llcp.c
> +++ linux-stable/net/nfc/llcp/llcp.c
> @@ -1182,8 +1182,8 @@ int nfc_llcp_register_device(struct nfc_
>   		goto err_rx_wq;
>   	}
>
> -	local->sockets.lock = __RW_LOCK_UNLOCKED(local->sockets.lock);
> -	local->connecting_sockets.lock = __RW_LOCK_UNLOCKED(local->connecting_sockets.lock);
> +	rwlock_init(&local->sockets.lock);
> +	rwlock_init(&local->connecting_sockets.lock);
>
>   	nfc_llcp_build_gb(local);
>
