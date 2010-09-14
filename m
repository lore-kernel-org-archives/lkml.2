Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0INAzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:55:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55809 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0INAzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a/oJA9QpNkKwbp7cek6FLWL09K88JRr6feh9ehJgbZb4FyK++nzLwcfgFQwReP2Fle
         uFBHFxFNc/oQywkj40qn7uN8tGcv1bpCE7mbpTvHhja/OVb+DMHLccHWVxNBo9yWEkqP
         MEkvpUsotlOaq5Efx4Qp5bbeQSR5ilM/49glk=
MIME-Version: 1.0
In-Reply-To: <1063862301.9960720.1284413345428.JavaMail.fmail@mwmweb063>
References: <1063862301.9960720.1284413345428.JavaMail.fmail@mwmweb063>
Date: Tue, 14 Sep 2010 08:55:21 +0800
Message-ID: <AANLkTimw5yPtTm2DVwJ30cz9Oq5RskA1e34JGtDfgFx_@mail.gmail.com>
Subject: Re: active memory - ok, but per process ?
From: jovi zhang <bookjovi@gmail.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not a vm subsystem experts, but maybe I can give my own comments.
Actually it's hard to maintenance per-process active pages. active
pages include many file page caches, not only per-process pages, these
caches don't belong to any process.(like some share library code
page).
So apparantly there have many common active mm through all process. is
this active mm number useful for you?
Maybe you can take some useful number like RSS & VSZ .(ps aux)

On Tue, Sep 14, 2010 at 5:29 AM, <devzero@web.de> wrote:
>
> Hi,
>
> pardon - a user question, most likely for vm subsystem experts.
> I`m searching for this for a while and don`t know any further.....
>
> as we know  ,
>
> cat /proc/meminfo |grep Active
> Active:         139916
> kB
>
> gives the " Memory that has been used more recently and usually not reclaimed unless absolutely necessary."
>
> I wonder - isn`t there a way to break that down on a per-process basis ? (to see which process is the most active memory "consumer")
>
> regards
> Roland﻿
> ___________________________________________________________
> Neu: WEB.DE De-Mail - Einfach wie E-Mail, sicher wie ein Brief!
> Jetzt De-Mail-Adresse reservieren: https://produkte.web.de/go/demail02
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
