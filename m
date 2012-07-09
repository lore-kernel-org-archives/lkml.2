Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2GIQdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:33:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2GIQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:33:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Mon, 9 Jul 2012 16:33:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <201207091532.12256.arnd@arndb.de> <20120709160212.GD15120@arm.com>
In-Reply-To: <20120709160212.GD15120@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207091633.08052.arnd@arndb.de>
X-Provags-ID: V02:K0:6kFXIL6scNVbjToFzEmCXfXIKIYviGdxF63+gkGpkRO
 mVWGFsykqxwvcM8NJgBTtAPInUJF87iEkjg6lDKyaIQC9j8S8q
 1CEdIlEBA+FwMlUKmetLx7xJ2ywJcqNV3Ve8rCVIGVBbW4m/yO
 bNPW5emsg8tKAHyUrBxRaJPeexuSnqZqbKsvjAaeSaG7SNUPVH
 TkLCF3+2ROP0/KqBLZJULdcp0ns9WqP7gRs4M/TY4oOzfOuIXB
 jLRCvYCREDGCY53AyQL7GokxNZVp5ydg57mbxTYTSi/WT8OPMW
 WhT4yHB7T4jF9VA1TPuYhyvMK+4g0W5sTCXt1SpdGquJ9PtaWi
 PpePVx1GiYAPaKCGMOzQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2012, Catalin Marinas wrote:
> On Mon, Jul 09, 2012 at 04:32:11PM +0100, Arnd Bergmann wrote:
> > We have a lot of reviewers that are familiar with the 32 bit code, so
> > I think the main strategy should be to spot duplicate code early
> > and make sure we deal with it individually. Examples for this are
> > probably the implementations for kvm and perf, which largely deal
> > with the same hardware on both architectures. Those definitely must
> > not get duplicated into mostly-identical files. In many cases, we're
> > moving those things into drivers/*, in other cases we might want to
> > use Makefile logic to include a sub-directory from one arch into another,
> > as we do for arch/um.
> 
> I don't see why we would need to get a subdir from one into the other.
> If the SoCs would need some common drivers (like GPIO), they should go
> into drivers/ anyway. There is some perf code that could be shared
> (though not building a subdir as we have different instruction sets) but
> I would like that moved to a more generic place.

I think either way works for the two examples I've given, we can do
whatever people are more comfortable with. All architectures today have
kvm and perf under arch/*/* so we could keep it that way and do an
ugly redirect, or we could get everyone to move to drivers/.

	Arnd
