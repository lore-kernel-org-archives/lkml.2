Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1DEFrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 01:47:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57307 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1DEFrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Tab26VO5gpPJWomppydWfdjTJav06BAAIUPDsquwzWc99vH6uepsEedLe+VIhMJUnn
         L2AxVrlC5wFzZp3m++ig==
MIME-Version: 1.0
In-Reply-To: <BANLkTimhk_G0fapzHAf0Gc-XhqT0qu+VbQ@mail.gmail.com>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
	<4D959058.7010606@codeaurora.org>
	<BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
	<4D981EAB.8070209@codeaurora.org>
	<BANLkTimhk_G0fapzHAf0Gc-XhqT0qu+VbQ@mail.gmail.com>
Date: Mon, 4 Apr 2011 22:46:58 -0700
X-Google-Sender-Auth: FRriWr4Td-Pk21tzKf02V9ARq3Y
Message-ID: <BANLkTinvbd9hmcsxhWQtM70uBzgv7sESTQ@mail.gmail.com>
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

On Mon, Apr 4, 2011 at 7:29 PM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
...
> I am using CONFIG_BUG=y, however I don't have CONFIG_DEBUG_BUGVERBOSE
> and hence I fall into the part which doesn't print the file and the
> line where the BUG was found.
>
> With Simon's patch if my .config had:
>
> CONFIG_BUG=y
> CONFIG_GENERIC_BUG is not set

In this case the patch is like a nop.

> CONFIG_DEBUG_BUGVERBOSE is not set
>
> I would fall into the same BUG definition that is causing issues:
>
> #define BUG()           do { *(int *)0 = 0; } while (1)
>
> OTOH, is not like "Use generic BUG() handler" gives the choice of
> removing GENERIC_BUG given that it is not prompted in menuconfig and
> auto selected, if this is the intention is there any reason to keep
> the #else part of /* not CONFIG_GENERIC_BUG */? there is no way we can
> use it with this patch, right?

Well, er, the intention is that you use the patch. I kept the old code
around since people can then simply change the Kconfig option and be
back where they were, as indeed you have. I would be happy to remove
the old behavior, but I was concerned about a possible roasting in
this forum. Changing long-established behavior is sometimes tricky.

Regards,
Simon

>
> Regards,
>
> Omar
>
