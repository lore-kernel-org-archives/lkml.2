Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1DEQn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:43:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1DEQn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nog2vKAWhQP+1b70/0Cc1qPR7NKEkGFxaN3nAyJFVSqjuG/u6wxAJQKzbWMJbIEtCt
         doskfIEmNgljjgfA88dg==
MIME-Version: 1.0
In-Reply-To: <BANLkTik3Rf_NUNnqQLPxRdokJzFLcZPK9w@mail.gmail.com>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
	<4D959058.7010606@codeaurora.org>
	<BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
	<4D981EAB.8070209@codeaurora.org>
	<BANLkTimhk_G0fapzHAf0Gc-XhqT0qu+VbQ@mail.gmail.com>
	<BANLkTinvbd9hmcsxhWQtM70uBzgv7sESTQ@mail.gmail.com>
	<BANLkTik3Rf_NUNnqQLPxRdokJzFLcZPK9w@mail.gmail.com>
Date: Tue, 5 Apr 2011 09:43:22 -0700
X-Google-Sender-Auth: ds3ZMnuegw5HuNHJH9ov3dM5LlE
Message-ID: <BANLkTima5DM6gm-1E_uGsM3cqPGd-U_how@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: Simon Glass <sjg@chromium.org>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 9:02 AM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
> Hi,
>
> On Tue, Apr 5, 2011 at 12:46 AM, Simon Glass <sjg@chromium.org> wrote:
>> On Mon, Apr 4, 2011 at 7:29 PM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
>> ...

>>> OTOH, is not like "Use generic BUG() handler" gives the choice of
>>> removing GENERIC_BUG given that it is not prompted in menuconfig and
>>> auto selected, if this is the intention is there any reason to keep
>>> the #else part of /* not CONFIG_GENERIC_BUG */? there is no way we can
>>> use it with this patch, right?
>>
>> Well, er, the intention is that you use the patch. I kept the old code
>> around since people can then simply change the Kconfig option and be
>> back where they were, as indeed you have. I would be happy to remove
>> the old behavior, but I was concerned about a possible roasting in
>> this forum. Changing long-established behavior is sometimes tricky.
>
> Yes, but you can't change the Kconfig because it is not prompted with
> your patch, if that was the intention then an option to de/select
> GENERIC_BUG or not is needed:
>
> arch/arm/Kconfig
> @@ -204,6 +204,10 @@ config MMU
>          Select if you want MMU-based virtualised addressing space
>          support by paged memory management. If unsure, say 'Y'.
>
> +config GENERIC_BUG
> +       bool "Generic BUG"
> +       default y
> +       depends on BUG

Yes that's right, it is a manual edit. But if there are no objections
I will create a patch to remove this and replace the old bug
infrastructure entirely. - Simon

>
> Regards,
>
> Omar
>
