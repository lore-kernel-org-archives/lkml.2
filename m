Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1BEBBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 20:01:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36452 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1BEBBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 20:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Sen28d/CdgsK55+w5FkIH/1iex7W2J4ffQ/S0nIwhe9rUmbw9cVtkRaEQ1SJm5JAcA
         /8eBohU81pmHcSR4vCJWIdAdFK8e0twY3TaH2G5AnsUwrB4WttDEB3zg3i84Jdg1QgVt
         S5rdqfUKnO/pODyEpqe3k/UXGtgyLzqs5+8S0=
Date: Sat, 5 Feb 2011 02:00:54 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: Filip Honckiewicz <f.honckiewicz@gmail.com>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110205010053.GC13060@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	Filip Honckiewicz <f.honckiewicz@gmail.com>,
	Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
	linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
	akpm@linux-foundation.org, andrea.gelmini@gelma.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20110201232750.GA30800@ulf>
 <20110204143529.f49e92e5.rdunlap@xenotime.net>
 <4D4C8EFA.40207@landley.net>
 <AANLkTi=O4C-JRbosVKag-QQiGODbrAznn3=EnoOET6BR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=O4C-JRbosVKag-QQiGODbrAznn3=EnoOET6BR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 01:28:50AM +0100, Filip Honckiewicz wrote:
> Hello Ulf!
> 
> I'm working on pretty same thing also in python... Now I'm sad,
> because you made it and I don't, and also my code looks like dung in
> comparison to yours. How long did you make this?

You didn't see the early versions ;)

I was a bit afraid that someone would come out with something similar
before it was done. Now you've given me a bad conscience :(

I've been working on it on and off in my spare time for six months or so.
Originally it was a project for automatically generating a minimal kernel for a
given system by automatically turning off options one by one and testing the
resulting kernel in an emulator (yeah, the minimal kernel you get out of that
process is broken in many ways, but you get some idea of what's needed and
what's not at least). That then grew into a general-purpose library.

> 
> BTW. "SLOW_WORK" symbol used in drivers/gpu/drm/Kconfig in "menucofnig
> DRM" as one of selects isn't an unnecessary symbol? I can't find any
> SLOW_WORK entry.

iscriptconfig says

A Config instance 'c' for the architecture (i386) has been created.
>>> c["SLOW_WORK"].is_defined()
False

so yes, it it's undefined on i386 at least. Grepping through the kernel shows
it only appears in drivers/gpu/drm/Kconfig, so it's in fact undefined on all
arches.

/Ulf
