Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab2JKUoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:44:14 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:50873 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2JKUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:44:12 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: Documentation of kconfig language differs from implementation regarding existence of symbols
Date: Thu, 11 Oct 2012 22:44:07 +0200
User-Agent: KMail/1.13.5 (Linux/3.6.1-treguer; KDE/4.4.5; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, Martin Walch <walch.martin@gmx.de>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Arnaud Lacombe <lacombar@gmail.com>
References: <1940598.VZE8PFWQyj@tacticalops> <50772BB8.6080404@suse.cz>
In-Reply-To: <50772BB8.6080404@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210112244.07609.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, Martin, All,

On Thursday 11 October 2012 22:27:36 Michal Marek wrote:
> Dne 10.10.2012 02:17, Martin Walch napsal(a):
> > The file linux/Documentation/kbuild/kconfig-language.txt says:
> > 
> >> The following two methods produce the same kconfig symbol
> >> dependencies but differ greatly in kconfig symbol existence
> >> (production) in the generated config file.
> >> 
> >> case 1:
> >> 
> >> config FOO tristate "about foo" depends on BAR
> >> 
> >> vs. case 2:
> >> 
> >> if BAR config FOO tristate "about foo" endif
> >> 
> >> In case 1, the symbol FOO will always exist in the config file
> >> (given no other dependencies).  In case 2, the symbol FOO will
> >> only exist in the config file if BAR is enabled.
> > 
> > However, I can not reproduce this. The attached file contains both
> > cases. When running make menuconfig, setting BAR0 and BAR1 both to
> > n, and saving the configuration, there is neither FOO0 nor FOO1 in
> > the resulting configuration file.
> 
> Indeed, that paragraph seems wrong. I think we should revert commit
> 64b81ed. Randy, Arnaud?

I just tested with Martin's example, and:
  - indeed, both symbols appear as "is not set",
  - that paragraph was already wrong for Kconfig at #64b81ed.

Before we trim that paragraph away, what's the purpose of the expected
difference in behavior for the two constructs?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
