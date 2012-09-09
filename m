Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2IIVz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:55:59 -0400
Received: from ares07.inai.de ([5.9.24.206]:49686 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab2IIVz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:55:57 -0400
Date: Sun, 9 Sep 2012 23:55:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Michal Marek <mmarek@suse.cz>
cc: Tzafrir Cohen <tzafrir.cohen@xorcom.com>,
        Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH] Add mach-specific includes
In-Reply-To: <5040BFF3.6050705@suse.cz>
Message-ID: <alpine.LNX.2.01.1209092355160.22738@frira.zrqbmnf.qr>
References: <1344764843-2179-1-git-send-email-tzafrir.cohen@xorcom.com> <5040BFF3.6050705@suse.cz>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-08-31 15:45, Michal Marek wrote:
>>  # Build header package
>>  (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
>>  (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
>> +if echo arch/$SRCARCH/mach-*/include | grep q -v '*'; then
>
>This should probably be grep -q, but it's quite ugly anyway.

Use of -q should probably be preferred to >/dev/null,
because with the latter, you will still pay the price
of printf.
