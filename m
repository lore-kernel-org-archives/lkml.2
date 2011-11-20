Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1KTW2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 17:28:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39170 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1KTW2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 17:28:40 -0500
Date: Sun, 20 Nov 2011 14:28:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Meyer <thomas@m3y3r.de>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mrst: Casting (void *) value returned by kmalloc
 is useless
In-Reply-To: <CAOJsxLEZF_pLUT-OOfh8GhWkS9RPVLwEfZutzZBDh4ysjvV0Qw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111201427270.30815@chino.kir.corp.google.com>
References: <1321569820.1624.244.camel@localhost.localdomain> <20111118101628.5013a1ea@pyx> <CAOJsxLEZF_pLUT-OOfh8GhWkS9RPVLwEfZutzZBDh4ysjvV0Qw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1442011655-1321828118=:30815"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1442011655-1321828118=:30815
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 18 Nov 2011, Pekka Enberg wrote:

> >> diff -u -p a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
> >> --- a/arch/x86/platform/mrst/mrst.c 2011-11-07 19:37:40.283168752 +0100
> >> +++ b/arch/x86/platform/mrst/mrst.c 2011-11-08 09:19:24.686513740 +0100
> >> @@ -331,7 +331,7 @@ static int __init sfi_parse_gpio(struct
> >>       num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
> >>       pentry = (struct sfi_gpio_table_entry *)sb->pentry;
> >>
> >> -     gpio_table = (struct sfi_gpio_table_entry *)
> >> +     gpio_table =
> >>                               kmalloc(num * sizeof(*pentry), GFP_KERNEL);
> 
> On Fri, Nov 18, 2011 at 12:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > True but the formatting also wants fixing with that change.
> 
> A conversion to kcalloc() would make sense as well.

Seems unnecessary to zero the array if it's going to immediately copy the 
gpio table, though.
--397155492-1442011655-1321828118=:30815--
