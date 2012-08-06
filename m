Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2HFO5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:57:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51262 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2HFO5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:57:52 -0400
Mime-Version: 1.0 (1.0)
References: <CAL7r9b39L1HuKis+PxOh9tAJ0iEwsP2c+k+=6w00JWCa=FwW5w@mail.gmail.com>
 <87vcgwzwsj.fsf@rustcorp.com.au>
In-Reply-To: <87vcgwzwsj.fsf@rustcorp.com.au>
From: =?UTF-8?Q?Barbaros_Tokao=C4=9Flu?= <barbarost@gmail.com>
Date: Mon, 6 Aug 2012 17:57:44 +0300
Message-ID: <-4432125333109111762@unknownmsgid>
Subject: Re: [PATCH] module: Fix compile error for ref_module when
 CONFIG_MODULES is not set
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

You are right, this was not for something in the kernel. I needed
ref_module to add some sort of dynamic dependency between modules but
this caused compile error when CONFIG_MODULES is not set. Another
option was using #ifdef CONFIG_MODULES check but the way in the patch
seemed correct to me.

However, if ref_module is exported only for ksplice, then you can
ignore this patch.

Thanks,
Barbaros

On Aug 6, 2012, at 9:58 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 1 Aug 2012 20:57:07 +0300, Barbaros Tokaoğlu <barbarost@gmail.com> wrote:
>> ref_module function is not defined when CONFIG_MODULES is not set thus
>> it causes compile error when a module which is set to be built-in uses it.
>> This patch defines a dummy ref_module function when CONFIG_MODULES
>> is not set.
>>
>> Signed-off-by: Barbaros Tokaoğlu <barbarost@gmail.com>
>
> Hi Barbaros,
>
>       It's usually a good idea to paste the error message into the
> commit message for compile fixes: it helps people googling the problem.
>
> In this case, it's particularly important, because I can't find any
> users of ref_module() outside module.c itself: it's only exported for
> ksplice to use.
>
> Cheers,
> Rusty.
