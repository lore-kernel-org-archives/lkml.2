Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0G2Q5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:57:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57231 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0G2Q5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FWmJy3GSoYSbvsupUT1JwNqzrNxueB43OooL14OWuHjiGqdUuResPSuEsnrIjoz4M7
         GlZ6sEF39NGCVFzE6fL9ya9S9y8scnZ1lm3NbmZGXtV4MNkC4LJVbBw0L2nwBC+9hGwn
         1JvcE3VFEcqhzKUW0MyIn3Vl+MjuDnpeZqSbU=
MIME-Version: 1.0
In-Reply-To: <1280422122.17322.14.camel@groeck-laptop>
References: <1280422122.17322.14.camel@groeck-laptop>
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 29 Jul 2010 12:56:54 -0400
Message-ID: <AANLkTi=zaf-hGOuNX05Qq+dw3Wq_xYxT5EvKTS_dRV0s@mail.gmail.com>
Subject: Re: alpha defconfig build broken in 2.6.35-rc6
To: guenter.roeck@ericsson.com
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        "Morten H. Larsen" <m-larsen@post6.tele.dk>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:48 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> During unrelated testing, I noticed that the alpha defconfig build is
> broken in 2.6.35-rc6. I get the following error message.
>
> arch/alpha/kernel/built-in.o: In function `cia_cab_init_pci':
> /opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:249:
> undefined reference to `ns87312_enable_ide'
> /opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:249:
> undefined reference to `ns87312_enable_ide'
> arch/alpha/kernel/built-in.o: In function `cabriolet_init_pci':
> /opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:242:
> undefined reference to `ns87312_enable_ide'
> /opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:242:
> undefined reference to `ns87312_enable_ide'
> arch/alpha/kernel/built-in.o: In function `takara_init_pci':
> /opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_takara.c:267:
> undefined reference to `ns87312_enable_ide'
> arch/alpha/kernel/built-in.o:/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_takara.c:267: more undefined references to `ns87312_enable_ide' follow
>
> Not surprising since ns87312.c and thus ns87312_enable_ide() no longer
> exist. The problem was introduced with commit
> 932e0c201d28a728e25d3b641aa95bd28ceb08b4 (alpha: Detect Super IO chip,
> no IDE on Avanti, enable EPP19).
>
> Guenter

Ah, thanks for the report. Either I or Morten will knock this out quickly.

Thanks,
Matt
