Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1C2Qj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:39:56 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49331 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1C2Qjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:39:54 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Shyam_Iyer@Dell.com, jbarnes@virtuousgeek.org, mjg59@srcf.ucam.org,
        Narendra_K@Dell.com, viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Matt_Domsch@Dell.com, Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
	<20110328080220.1390d28e.randy.dunlap@oracle.com>
	<DBFB1B45AF80394ABD1C807E9F28D15702659CFB3D@BLRX7MCDC203.AMER.DELL.COM>
	<4D90EDE8.9070306@oracle.com> <87oc4u4rn4.fsf@devron.myhome.or.jp>
	<4D92063C.8040202@oracle.com>
Date: Wed, 30 Mar 2011 01:39:46 +0900
In-Reply-To: <4D92063C.8040202@oracle.com> (Randy Dunlap's message of "Tue, 29
	Mar 2011 09:18:04 -0700")
Message-ID: <8739m5519p.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

>> config PCI_LABEL
>> 	bool
>>         select NLS
>>         depends on (DMI || ACPI)
>
> What sets/enables it then?
> or did you mean:
> 	def_bool y
> and in that case, should it be a user-visible & user-changeable kconfig option?

Whoops, last line was missed by copy&paste. It meant

config PCI_LABEL
	bool
	select NLS
	depends on (DMI || ACPI)
        default y

And no, it shouldn't be user-changeable (it would be better to
invisible in .config. At make *config, already invisible.). Because
PCI_LABEL is not user config and not used in Makefile.

And yeah, if you like def_bool

config PCI_LABEL
	def_bool y if (DMI || ACPI)
	select NLS

I guess it would work (it should be just syntax sugar and equivalent).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
