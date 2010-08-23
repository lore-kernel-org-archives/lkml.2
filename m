Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0HWBB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:01:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0HWBB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=DtHbOlaA57oGle3nhL9EPAXQTG2Y8zj4yp12Pr4QZvTYoo2Rw5JQ9Za8qEXpwGJsY2
         //OAuJaqAyISeiG7KCMyqD798+GbXKLqxxG6zcH2mI4OK9q5r8JbRhvDd+AUhq/fcBuw
         ClUPyCtzOgVqTITJ2x6N+Wewvh1duwOgtcop0=
References: <1282520629-6542-1-git-send-email-nikitasangelinas@googlemail.com>
Message-Id: <815E5C3B-CAB4-4BA0-8D41-301F512D13D3@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nikitas Angelinas <nikitasangelinas@googlemail.com>
In-Reply-To: <1282520629-6542-1-git-send-email-nikitasangelinas@googlemail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7E18)
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: [PATCH] kernel: time: use ARRAY_SIZE macro in timecompare.c
Date: Sun, 22 Aug 2010 18:01:44 -0700
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikitas Angelinas <nikitasangelinas@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 22, 2010, at 4:43 PM, Nikitas Angelinas <nikitasangelinas@googlemail.com 
 > wrote:

> Replace sizeof(buffer)/sizeof(buffer[0]) with ARRAY_SIZE(buffer) in
> kernel/time/timecompare.c
>
> Signed-off-by: Nikitas Angelinas <nikitasangelinas@googlemail.com>
> ---
> kernel/time/timecompare.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
> index ac38fbb..a9ae369 100644
> --- a/kernel/time/timecompare.c
> +++ b/kernel/time/timecompare.c
> @@ -21,6 +21,7 @@
> #include <linux/module.h>
> #include <linux/slab.h>
> #include <linux/math64.h>
> +#include <linux/kernel.h>
>
> /*
>  * fixed point arithmetic scale factor for skew
> @@ -57,11 +58,11 @@ int timecompare_offset(struct timecompare *sync,
>    int index;
>    int num_samples = sync->num_samples;
>
> -    if (num_samples > sizeof(buffer)/sizeof(buffer[0])) {
> +    if (num_samples > ARRAY_SIZE(buffer)) {
>        samples = kmalloc(sizeof(*samples) * num_samples, GFP_ATOMIC);

That should be kcalloc while you are at it.

Thanks.

-- 
Dmitry

