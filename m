Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0FVQzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:55:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40407 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0FVQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CQx103zV7dZTS8pZI05S0yu/OXt7ReZjaE+Wfz7PFCpd1RJd4CdlvVbNxkfKtV04S/
         iqqXh9VddyOpObCURT7cIH28fGQzJF77YvRzWeoyO+cQbJixnERa8Qln1c+toy/c0lOw
         RaDB9+LZXpuYrCVUVRUwpA3X3KyGXEYBhDtd8=
Date: Tue, 22 Jun 2010 20:55:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: "Song, Barry" <Barry.Song@analog.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80:
 Reworkprobing/JEDEC code
Message-ID: <20100622165545.GA10255@oksana.dev.rtsoft.ru>
References: <AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com>
 <20100618133212.GA5276@oksana.dev.rtsoft.ru>
 <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com>
 <AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com>
 <20100621071551.GA16109@oksana.dev.rtsoft.ru>
 <AANLkTiknH95loHJsQNxvCCyQbriCFWqM5LHl3wKzmdWX@mail.gmail.com>
 <20100621073909.GA20674@oksana.dev.rtsoft.ru>
 <AANLkTinjhmkQafVlrtQC5yDnqIZz859_wrZqo45QOEJ2@mail.gmail.com>
 <20100621112049.GA9273@oksana.dev.rtsoft.ru>
 <AANLkTikY9pfHsQ6xeVkixKF5kqL2nLyV2kgcR2iJKhG-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikY9pfHsQ6xeVkixKF5kqL2nLyV2kgcR2iJKhG-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 02:37:52PM +0800, Barry Song wrote:
[...]
> >                jid = jedec_probe(spi);
> >                if (!jid) {
> > -                       dev_info(&spi->dev, "non-JEDEC variant of %s\n",
> > -                                id->name);
> > +                       return -ENODEV;
> The patch looks good to me. Only problem is NULL is also returned by
> spi_write_then_read() fail:
[...]
> Here much better for -EIO (return tmp)?

Agreed. Though, this is not a regression, and I guess desires
its own patch. 

Here are two patches, one for 2.6.35 (minimal changes to fix
the JEDEC problem), another for 2.6.36.
