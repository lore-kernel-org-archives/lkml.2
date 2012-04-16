Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2DPOPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:15:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61330 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2DPOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:15:37 -0400
From: Paul Moore <paul@paul-moore.com>
To: libseccomp-discuss@lists.sourceforge.net
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [libseccomp-discuss] ANN: libseccomp
Date: Mon, 16 Apr 2012 10:15:33 -0400
Message-ID: <4892415.SaF4mnePOG@sifl>
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
In-Reply-To: <20120414024708.GB10926@khazad-dum.debian.net>
References: <1540670.AFBi1SpGoi@sifl> <9270063.OgsgoBpmh0@sifl> <20120414024708.GB10926@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 13, 2012 11:47:08 PM Henrique de Moraes Holschuh wrote:
> On Fri, 13 Apr 2012, Paul Moore wrote:
> > the seccomp filter into the kernel.  By default libseccomp attempts to set
> > NO_NEW_PRIVS but does not fail if prctl(NO_NEW_PRIVS) returns with an
> > error;
>
> Isn't that dangerous in non-obvious ways, as in it can actually
> cause/activate/enable/open security issues on priviledged processes that
> don't expect whatever filtering seccomp will subject them to?

We could debate this point but it turns out it is a bit of a non-issue as the 
kernel code requires NO_NEW_PRIVS unless CAP_SYS_ADMIN is set; if neither 
conditions are true the seccomp filter with fail (check Will's patches).

If prctl(NO_NEW_PRIVS) fails the error is always returned, and the 
attribute/boolean to disable this functionality has been removed since it 
likely serves little purpose.

> Defaults are important, as they're what people _who don't know any better_
> are likely to use.

Agreed.  You'll never hear me argue otherwise.

-- 
paul moore
www.paul-moore.com

