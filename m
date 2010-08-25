Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0HYN4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:56:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52865 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0HYN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:56:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Wed, 25 Aug 2010 15:55:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <4C61EE55.5030506@codeaurora.org> <201008251414.16411.arnd@arndb.de> <20100825125451.GH2153@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100825125451.GH2153@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008251555.53653.arnd@arndb.de>
X-Provags-ID: V02:K0:KkOyTKyh6oDwRXjRRs5fiTNuxqgOItWJWpeNroJwYx4
 0wAB8hrr8IiEwcMJw0klO8lZDlPzFQ4b5zgUNcBmEyEbN7bsXR
 rxJj+v3shNKHIIq2w5pg4IZcLI9NykWOSAUl6rxPiVEHgz5I5I
 jCZQx3fiH/SiFMBZpEpb7dVlINNSNCyac1m8s1sqyu8UA/NIgM
 bhIqTphBk6SS8KYmxcrag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 August 2010, Heiko Carstens wrote:
> 
> On Wed, Aug 25, 2010 at 02:14:16PM +0200, Arnd Bergmann wrote:
> > > Then maybe add a "choice" Kconfig option in a way that both allyesconfig
> > > as well as allnoconfig will build?
> > 
> > I think it would be easier to remove the config option entirely on s390
> > and just always warn. As I said earlier in this thread, I generally
> > don't think this particular warning is more important than a lot of
> > the other ones that we don't turn into errors.
> 
> I disagree: a default kernel build should compile without the noise of
> tens of false positive warnings.
> Nobody would look at new warnings and fix possible bugs.
> That's why I want to have an option to turn the warnings off (default).
> 
> Or are you volunteering to "fix" all the false positives? :)

If you don't want to see the warnings, then just remove the strict checks.
We already concluded that there is little value in them on s390 since it only
shows false postives.

Maybe the easiest way would be to rename the option on s390 and move all
the other ones into a common place.

	Arnd
