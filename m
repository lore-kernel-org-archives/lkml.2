Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2CTLcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:32:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46076 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2CTLcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:32:17 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Christoph Lameter" <cl@linux-foundation.org>,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Tejun Heo" <tj@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Lai Jiangshan" <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/6] kenrel.h: add ALIGN_OF_LAST_BIT()
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
 <1332238884-6237-2-git-send-email-laijs@cn.fujitsu.com>
Date: Tue, 20 Mar 2012 12:32:14 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wbgvn00x3l0zgt@mpn-glaptop>
In-Reply-To: <1332238884-6237-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012 11:21:19 +0100, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Get the biggest 2**y that x % (2**y) == 0 for the align value.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/kernel.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 5113462..2c439dc 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -44,6 +44,8 @@
>  #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
>  #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
>+#define ALIGN_OF_LAST_BIT(x)	((((x)^((x) - 1))>>1) + 1)

Wouldn't ALIGNMENT() be less confusing? After all, that's what this macro is
calculating, right? Alignment of given address.

> +
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> /*


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
