Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0KYNSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:18:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0KYNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:18:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Kent <raven@themaw.net>
Subject: Re: autofs4 hang in 2.6.37-rc1
Date: Thu, 25 Nov 2010 14:17:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, autofs@linux.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4CDFDC2B.6040205@redhat.com> <201011150954.34289.arnd@arndb.de> <1290052468.2465.7.camel@perseus.themaw.net>
In-Reply-To: <1290052468.2465.7.camel@perseus.themaw.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251417.52010.arnd@arndb.de>
X-Provags-ID: V02:K0:fUGqbrLdE1/8m/jLhzMI69HyPILLrSf6Gyp5itvyWf3
 4RndUi2ADeMiDmczB4W20G98pClr5jY/0zLyDUb0M2oYrXppDS
 s0yNNLxlwJQXF/L97659JH1q4PF/r7qSolkinMiXyhzPBLFO6p
 Yp4ErgmK+tgWZ7sNVgUE7p66A8L5B+iKXXqi9uvTtqhS4ZPaPs
 RUHWqDdQuMIQEITZgcUjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 November 2010, Ian Kent wrote:
> But the important thing to notice is that the new ioctl interface (in
> fs/autofs4/dev-ioctl.c) used the unlocked_ioctl method since it was
> merged in 2.6.28 and that calls back into the core ioctl code for its
> major functionality. So the core function of the ioctl interface has
> been used without the BKL for quite a while now and has been heavily
> exercised in subsequent testing since the new ioctl interface has been
> in place.
> 
> I can't see any reason for keeping the autofs4_ioctl_mutex.

Ok. Are you submitting a patch to remove it? Your reasoning absolutely
makes sense and we need to fix this regression.

	Arnd
