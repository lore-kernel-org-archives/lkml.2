Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0HKVRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 17:17:05 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:57964 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931Ab0HKVRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 17:17:00 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] matroxfb: fix incorrect use of memcpy_toio()
Date: Wed, 11 Aug 2010 23:16:48 +0200
User-Agent: KMail/1.9.10
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201008112227.44990.linux@rainbow-software.org> <20100811134136.c53f8eba.akpm@linux-foundation.org>
In-Reply-To: <20100811134136.c53f8eba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008112316.52063.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 August 2010 22:41:36 Andrew Morton wrote:
> On Wed, 11 Aug 2010 22:27:42 +0200
>
> Ondrej Zary <linux@rainbow-software.org> wrote:
> > Fix incorrect use of memcpy_toio() in matroxfb that broke in 2.6.34 on
> > x86.
>
> Thanks.
>
> What was incorrect about it?  And what is the user-visible effect of
> this regression?

Screen is completely corrupted since 2.6.34. Bisection revealed that it's 
caused by commit 6175ddf06b6172046a329e3abfd9c901a43efd2e. H. Peter Anvin 
explained that memcpy_toio() does not copy data in 32bit chunks anymore on 
x86.

See: http://lkml.org/lkml/2010/8/2/409

-- 
Ondrej Zary
