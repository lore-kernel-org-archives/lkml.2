Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0INSr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:47:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49262 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0INSr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Uav5owEdi8d46wkBrEAw2JSHLV1xtzCzcDH/NhKYLjAJbd92J4spgtTW6/3676ELw3
         AjprSCOwPdHBcOeQcjGjgnFAXpHG1AkbBbeYUSNGRgXRtCZ0RBbW15S+tLd8Jy36u8xA
         j2ndfve4LYIY1Ubd1X9GViUa0IAYs7uT5kpBc=
MIME-Version: 1.0
In-Reply-To: <AANLkTinhfKmxZRQNvXvtrwAp_y2Uz4PZj67m=QUr6=Va@mail.gmail.com>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
	<1284483964-2370-2-git-send-email-penberg@kernel.org>
	<AANLkTinxNbBQ3phKH8aoOSCO-+3FLn=te4OAqx4J8cU+@mail.gmail.com>
	<alpine.DEB.2.00.1009141227430.31857@router.home>
	<AANLkTim8xzipTHTCvGegkbuCoT51EZVox32xasQaq_yq@mail.gmail.com>
	<AANLkTinhfKmxZRQNvXvtrwAp_y2Uz4PZj67m=QUr6=Va@mail.gmail.com>
Date: Tue, 14 Sep 2010 21:47:54 +0300
X-Google-Sender-Auth: sFo668Tr8DoS5xQTCIp3msV6tcI
Message-ID: <AANLkTimDyADR9QMK7GNotq-5_LOSbuuMWQ-K5p6wUWWY@mail.gmail.com>
Subject: Re: [PATCH 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 9:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Looking at procps sources, slabtop and other utilities seem to think
>> slab cache names are limited to 64 bytes. Linus, are you OK with
>> adding a "+" character prefix for merged caches like you suggested in
>> private?
>
> I'd much rather see "x+y+z" and actually see what the slab entries are.
>
> But we can certainly also say "limit it to 64 bytes" and truncate
> things past that.

It's actually 63 bytes due to off-by-one error in procps. There never
has been such limit on the kernel side but I worry about breaking
other applications that are prepared to read even less characters. Oh
well, I'll send the reworked patches and let you decide.

                        Pekka
