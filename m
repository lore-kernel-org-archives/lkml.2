Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0FSNZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 09:25:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:29538 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0FSNZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 09:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=kOICts02Qvnw0LOe3TBt3wRIsEDvM7vXCtpc1wGAKM8Hi/H5WZ8n22isjP4QuL1sk3
         7m+XICBzgRS5ZEU0OGOeaZXxKhDnRrl8dzQ3LWHeFUExKG1pjQpzJ0JYsJ9AiRkPSK8l
         xHORFe1fX+C7DyRBAo5+gQc+8EJHPot4N4/AQ=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100619132055.GK18946@basil.fritz.box>
References: <200912081016.198135742@firstfloor.org> <20091208211647.9B032B151F@basil.firstfloor.org> 
	<AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com> 
	<20100619132055.GK18946@basil.fritz.box>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sat, 19 Jun 2010 15:25:16 +0200
Message-ID: <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com>
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft page 
	offlining
To: Andi Kleen <andi@firstfloor.org>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Thanks for this. Some comments below.

On Sat, Jun 19, 2010 at 3:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Jun 19, 2010 at 02:36:28PM +0200, Michael Kerrisk wrote:
>> Hi Andi,
>>
>> On Tue, Dec 8, 2009 at 11:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >
>> > Process based injection is much easier to handle for test programs,
>> > who can first bring a page into a specific state and then test.
>> > So add a new MADV_SOFT_OFFLINE to soft offline a page, similar
>> > to the existing hard offline injector.
>>
>> I see that this made its way into 2.6.33. Could you write a short
>> piece on it for the madvise.2 man page?
>
> Also fixed the previous snippet slightly.

(thanks)

> commit edb43354f0ffc04bf4f23f01261f9ea9f43e0d3d
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Sat Jun 19 15:19:28 2010 +0200
>
>    MADV_SOFT_OFFLINE
>
>    Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> diff --git a/man2/madvise.2 b/man2/madvise.2
> index db29feb..9dccd97 100644
> --- a/man2/madvise.2
> +++ b/man2/madvise.2
> @@ -154,7 +154,15 @@ processes.
>  This operation may result in the calling process receiving a
>  .B SIGBUS
>  and the page being unmapped.
> -This feature is intended for memory testing.
> +This feature is intended for testing of memory error handling code.
> +This feature is only available if the kernel was configured with
> +.BR CONFIG_MEMORY_FAILURE .
> +.TP
> +.BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
> +Soft offline a page. This will result in the memory of the page
> +being copied to a new page and original page be offlined. The operation

Can you explain the term "offlined" please.

> +should be transparent to the calling process.

Does "should be transparent" mean "is normally invisible"?

Thanks,

Michael

> +This feature is intended for testing of memory error handling code.
>  This feature is only available if the kernel was configured with
>  .BR CONFIG_MEMORY_FAILURE .
>  .TP
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
