Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0JVWJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 18:09:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37130 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0JVWJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 18:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RcooVThCHOgyO6rr6nnjsoj9uWbAU2npQn6lwaO/A2319xj/Ahqg57C5TV4rmf8hRR
         fOb0knOwJV/LhDQKU9IUQlXsOug5xEPokl32DjiNNDfA8Owv1H+82jgtJxbyUwJ2HHr+
         f6llXectpNhKXSIobqSiEENYhP8WLvKZHsLEo=
MIME-Version: 1.0
In-Reply-To: <1287784914-5714-1-git-send-email-iwamatsu@nigauri.org>
References: <1287784914-5714-1-git-send-email-iwamatsu@nigauri.org>
Date: Fri, 22 Oct 2010 15:09:01 -0700
Message-ID: <AANLkTinUS9HSDCG4F8o8rrAByNaOpchBd7LBKOF6SW3T@mail.gmail.com>
Subject: Re: [PATCH] rtc: rs5c313: Replase from ctrl_* to __raw_*
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 3:01 PM, Nobuhiro Iwamatsu <iwamatsu@nigauri.org> wrote:
> ctrl_* is deprecated. We should to use __raw_*.
>

>
>        /* And Initialize SCL for RS5C313 clock */
> -       scsptr1_data = ctrl_inb(SCSPTR1) | SCL; /* SCL:H */
> -       ctrl_outb(scsptr1_data, SCSPTR1);
> -       scsptr1_data = ctrl_inb(SCSPTR1) | SCL_OEN;     /* SCL output enable */
> -       ctrl_outb(scsptr1_data, SCSPTR1);
> +       scsptr1_data = __raw_readb(SCSPTR1) | SCL;      /* SCL:H */
> +       __raw_writeb(scsptr1_data, SCSPTR1);
> +       scsptr1_data = __raw_readb(SCSPTR1) | SCL_OEN;  /* SCL output enable */
> +       __raw_writeb(scsptr1_data, SCSPTR1);
>        RS5C313_CEDISABLE;      /* CE:L */
>  }

I think that you need a barrier between write and the subsequent read
as the __raw helpers do not
imply one.  Otherwise the write isn't guaranteed to be done before the read.

Harvey
