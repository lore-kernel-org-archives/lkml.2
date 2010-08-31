Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0HaWRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:17:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49167 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0HaWRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pTD6spLo2SE0QWQV78wvV8JRsvKOGNZc02bTDJn3j4noHzzW3y9KIEGq2gEIdNUjFI
         OxNds4lsfvaK+V5VRBz+WrzUB/sxFK5fT66pMv+yzxCXNuN7DTjLMPCG7lSPNd5anUn+
         /eN05OM8m/biflPG9Xup0aCBSrn5dXcuO0ecw=
MIME-Version: 1.0
In-Reply-To: <AANLkTin4cn84xu3go-Tj-CYSLp0W6uO1HRtA6_CQu8nJ@mail.gmail.com>
References: <201008271537.35709.ptesarik@suse.cz>
	<987664A83D2D224EAE907B061CE93D53015D91D6F5@orsmsx505.amr.corp.intel.com>
	<987664A83D2D224EAE907B061CE93D53015D9B14DC@orsmsx505.amr.corp.intel.com>
	<201008302341.14312.ptesarik@suse.cz>
	<AANLkTin4cn84xu3go-Tj-CYSLp0W6uO1HRtA6_CQu8nJ@mail.gmail.com>
Date: Tue, 31 Aug 2010 15:17:28 -0700
Message-ID: <AANLkTinHOpcdAJd0_4G=OFAnMZaXKeOsqnbjJMAxCume@mail.gmail.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
From: Tony Luck <tony.luck@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Hedi Berriche <hedi@sgi.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 3:43 PM, Tony Luck <tony.luck@intel.com> wrote:
> Does Hedi's test fail for you if you drop the fancy ALAT trick?
> I.e. just use "serve = *p;" in __ticket_spin_lock()?

Answering my own question ... it failed in 47 minutes with the breakit
script on iteration 2812 :-(

So it would appear that the problem isn't related to the ALAT, or weird
compiler optimizations around the inline asm.

-Tony
