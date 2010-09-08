Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0IHA1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:27:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36536 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0IHA1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=yBmrU2L/kyEcxyn4RusnD6AC593xhCrxmAWPxoKUNC1Ywzbe1iyLbVhiT0GAuQutG/
         dZySLrGYEXznWlpOViHt17SaPwaiy3hIQbMEx4XgUnTAHko+Hhc1gcs/BxnNWxS5qtkn
         r0YpxvqJ3bLKbFrHpfz/asQG98ufFD/3ZLpm4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimqn6=uzE9FawJkWe3w3+AipiMUUcjLd8fo48s1@mail.gmail.com>
References: <AANLkTimqn6=uzE9FawJkWe3w3+AipiMUUcjLd8fo48s1@mail.gmail.com>
Date: Wed, 8 Sep 2010 01:27:49 +0100
Message-ID: <AANLkTim0GX8bmZu8j5wVs11QFCmKjNK2MBkV7Mcha_Ae@mail.gmail.com>
Subject: Re: Promoting Crusoe and Geode Processors to i686 Status
From: Nick Lowe <nick.lowe@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two further questions...

1) Is there a benefit to keeping a CONFIG_MGEODEGX1 and
CONFIG_MGEODE_LX when we have a situation where i686
CONFIG_X86_GENERIC builds work?

# Geode GX1 support
cflags-$(CONFIG_MGEODEGX1)      += -march=pentium-mmx
cflags-$(CONFIG_MGEODE_LX)      += $(call
cc-option,-march=geode,-march=pentium-mmx)

2) Should there be the special case that forces the suboptimal
-mtune=generic32 to work around the binutils NOPL bug or, as I think,
should people just update to a sane binutils version? (It's a special
case triggered where CONFIG_X86_P6_NOP is not set.)

# Bug fix for binutils: this option is required in order to keep
# binutils from generating NOPL instructions against our will.
ifneq ($(CONFIG_X86_P6_NOP),y)
cflags-y                        += $(call
cc-option,-Wa$(comma)-mtune=generic32,)
endif

Reference: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/x86/Makefile_32.cpu;hb=HEAD

Cheers,

Nick
