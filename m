Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab1FQRKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:10:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64969 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1FQRKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qydw/Fs8Pf+coqP0mN5x33y040arY02AEYQbqfKMlw6UIcp7T1A+Q57oPQKKNDHOIg
         hKL+O3u25HFLUiDRj3ySJYaaZ7tZ4e0F8XXnq2F0A5mISmSYOui+OXNKpOkmyLlZrDTW
         5V/PyEvsM5iUFzwdEwEFEKx1FDxPbLIR7wG3w=
MIME-Version: 1.0
In-Reply-To: <1308298294.13535.3.camel@phoenix>
References: <1308298176.13535.1.camel@phoenix>
	<1308298294.13535.3.camel@phoenix>
Date: Fri, 17 Jun 2011 10:10:42 -0700
Message-ID: <BANLkTi=MiT1PrcJMdAfegTg74BQYNHC2fw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd: onenand/samsung.c: fix build error
From: Brian Norris <computersforpeace@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 17, 2011 at 1:11 AM, Axel Lin <axel.lin@gmail.com> wrote:
> -       err = mtd_device_parse_register(&info->mtd, NULL, 0,
> +       err = mtd_device_parse_register(onenand->mtd, NULL, 0,
>                        pdata ? pdata->parts : NULL,
>                        pdata ? pdata->nr_parts : 0);

Wouldn't it be just the same (and shorter) to use "mtd" instead of
onenand->mtd? Like:

       err = mtd_device_parse_register(mtd, NULL, 0,
                     pdata ? pdata->parts : NULL,
                     pdata ? pdata->nr_parts : 0);

Brian
