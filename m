Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0DJR4E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:56:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0DJR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:56:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] random: Forbid llseek on random chardev
Date: Sat, 10 Apr 2010 19:55:46 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1270909064-7845-1-git-send-regression-fweisbec@gmail.com> <1270916750.28124.23.camel@calx> <20100410163529.GI5204@nowhere>
In-Reply-To: <20100410163529.GI5204@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004101955.46644.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/6t22v/vYhlO9157vLo06sIgR2gsKF07vWowg
 qTw+r5/Bsck5L5oA786g4VudzAklB8cA65VBHyx85sGxAGiyAc
 0S5yc7HvVJp1JRo19evWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 April 2010 18:35:30 Frederic Weisbecker wrote:
> 
> > > Using generic_file_llseek means we no longer need to
> > > take the BKL if anyone tries to seek on these.
> > 
> > Comment doesn't match the patch?

Yes, my fault. The version in my series already had this problem.

> Oops. I guess the patch has been updated, but not the changelog.
> 
> Some background: we are trying to remove the uses of default_llseek
> that use the bkl. We started with turning llseek stubs to
> generic_file_llseek (or non seekable open in some cases), but we are
> hesitating now and think about actually turn all the stubs that
> might need the bkl into default_llseek, and fallback to
> generic_file_llseek for all other stubs.
> 
> Depending on what we do I'll resend you an updated version
> of this patch with generic_file_llseek, or I will let the stub
> as is.

The noop_llseek from Jan's series seems most appropriate here.

	Arnd
