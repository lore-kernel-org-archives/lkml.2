Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0H2K0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 06:26:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37261 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0H2K0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 06:26:32 -0400
Message-ID: <4C7A35C8.3010608@cs.helsinki.fi>
Date: Sun, 29 Aug 2010 13:26:16 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Vegard Nossum <vegardno@ifi.uio.no>, kernel-janitors@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] arch/x86/mm/kmemcheck: Remove double test
References: <1283010066-20935-1-git-send-email-julia@diku.dk> <1283010066-20935-5-git-send-email-julia@diku.dk>
In-Reply-To: <1283010066-20935-5-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.8.2010 18.41, Julia Lawall wrote:
> The opcodes 0x2e and 0x3e are tested for in the first Group 2 line as well.
>
> The sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @expression@
> expression E;
> @@
>
> (
> * E
>    || ... || E
> |
> * E
>    &&  ...&&  E
> )
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
> This is a guess as to what the code should be.  Perhaps something else
> should have been tested instead.

The last two items are branch hint prefixes that use same encoding as CS 
and DS segment override prefixes.

Reviewed-by: Pekka Enberg <penberg@kernel.org>

Can you pick this up in the x86.git tree, please?

>   arch/x86/mm/kmemcheck/opcode.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
> index 63c19e2..324aa3f 100644
> --- a/arch/x86/mm/kmemcheck/opcode.c
> +++ b/arch/x86/mm/kmemcheck/opcode.c
> @@ -9,7 +9,7 @@ static bool opcode_is_prefix(uint8_t b)
>   		b == 0xf0 || b == 0xf2 || b == 0xf3
>   		/* Group 2 */
>   		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
> -		|| b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
> +		|| b == 0x64 || b == 0x65
>   		/* Group 3 */
>   		|| b == 0x66
>   		/* Group 4 */
>

