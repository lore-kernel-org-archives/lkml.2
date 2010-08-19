Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0HSQ55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:57:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55078 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0HSQ5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZmMjShgamAok+tekXDc3U6tWkrtmm2Z0MA+PEj+OPg2Ag2TBF5YzGrygjXszBuFO7W
         UD6RiMqvbhwzi9jo0iBF+B0Ol+bBJkXDi4m3uXpTXOS7Xzf09ztMYovuOzJv7mio5ID4
         gohCrs36F4/Q3DCqpPbjOel3ryOCYKHX5XUY4=
Subject: Re: [PATCH 0/4] initramfs: remove sparse warnings
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201008191638.23248.arnd@arndb.de>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
	 <201008191638.23248.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 01:57:51 +0900
Message-ID: <1282237071.1713.15.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-19 (목), 16:38 +0200, Arnd Bergmann:
> On Thursday 19 August 2010, Namhyung Kim wrote:
> > This patchset removes most of sparse warnings in init/initramfs.c.
> > Current implementation of initramfs relies on syscall service rountins heavily
> > so it requires many of arguments to be __user address space pointers but, in
> > most cases, were missing proper markups. This patchset tries to fix those at
> > a minimum change.
> 
> I'm skeptical about this, you are adding obviously incorrect annotations
> to the code to make something work that was written without the awareness
> for address spaces.
> 
> A better way would be to call path_lookup or kern_path to look up the
> path and pass that to a lower-level file I/O function.
> 
> 	Arnd

Thanks for the comment. Then I'll try to refactor/reimplement initramfs
code based on your suggestion.

-- 
Regards,
Namhyung Kim


