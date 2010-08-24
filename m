Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0HXP0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:26:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54536 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0HXP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:26:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Tue, 24 Aug 2010 17:26:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <4C61EE55.5030506@codeaurora.org> <201008191309.15425.arnd@arndb.de> <20100824150655.GB2160@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100824150655.GB2160@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241726.08797.arnd@arndb.de>
X-Provags-ID: V02:K0:n+m73CpfBgJYiU0mCtBIIkY2eANonMMFtTTTdzuLjFk
 FKXSoQ58rJQMwrl7t4J439PgoocZHehAvPJ3ds9N+wFGLo0OyW
 rAyXnyOqVjtMZBduKrFKFx/03xCi4pMq6CtMSmOw/JcAiAxi+g
 Naqfn6tdo2JA4cmylNEKTsvxBG+TfAnP4MwSsMkHiKk3RQb1Il
 wIgd2mp/2/74faw2//F0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 August 2010, Heiko Carstens wrote:
> > (Taking Martin and Heiko on Cc for s390)
> > 
> > I'd strongly suggest making the behavior the same for everyone. It should
> > be fairly easy to make sure none of these warnings ever triggers
> > on s390, because most of the Linux device driver code does not get build
> > there anyway.
> 
> Please don't do that. An s390 allyesconfig still triggers 45 warnings and
> I'm currently not willing to "patch" working code just to get rid of these
> warnings which are most likely all false positives.
> That's the reason why we currently don't error out and only generate
> warnings.

Can't you just turn that option off then? Or are you worried about
allyesconfig builds?

The current state is confusing because on s390
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS means that gcc will warn rather
than ignore the finding, while on all others, the same option turns
a warning into an error.

Test-building an allmodconfig on s390 showed these warnings only in
architecture independent code, and I agree that they are all false
positives.

	Arnd
