Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1KILdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:33:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45636 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1KILdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:33:08 -0500
Date: Wed, 9 Nov 2011 12:33:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Haywood <tla@oak.selfip.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Build warning: kernel/trace/trace.c (v3.2-rc1-90-g19e0baf)
Message-ID: <20111109113303.GA18508@gere.osrc.amd.com>
References: <4EBA3E3E.9060402@oak.selfip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EBA3E3E.9060402@oak.selfip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:47:58AM +0000, Dave Haywood wrote:
> Hi,
> 
>   Noticed this new warning in the build of kernel v3.2-rc1-90-g19e0baf:
> 
>   CC      kernel/trace/trace.o
> kernel/trace/trace.c: In function 'tracing_mark_write':
> kernel/trace/trace.c:3644:8: warning: 'page2' may be used uninitialized in this function

That has to be gcc 4.5.x something. 4.6 is smarter in that aspect:

$ make CC=gcc-4.6 kernel/trace/trace.o
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s

  ...

  HOSTLD  scripts/mod/modpost
  CC      kernel/trace/trace.o
$ make CC=gcc-4.5 kernel/trace/trace.o
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s

  ...

  HOSTLD  scripts/mod/modpost
  CC      kernel/trace/trace.o
kernel/trace/trace.c: In function ‘tracing_mark_write’:
kernel/trace/trace.c:3644:8: warning: ‘page2’ may be used uninitialized in this function

HTH

-- 
Regards/Gruss,
Boris.
