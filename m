Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1IOOhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:37:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61819 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1IOOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:37:49 -0400
Subject: Re: a question regarding sys_poll() on x86_64 via tha ia32 layer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, mingo@redhat.com
In-Reply-To: <1316091669.6545.79.camel@localhost.localdomain>
References: <1316086860.6545.66.camel@localhost.localdomain>
	 <1316089435.2893.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1316091669.6545.79.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 16:37:56 +0200
Message-ID: <1316097476.2893.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 15:00 +0200, Thomas Meyer a écrit :
> Am Donnerstag, den 15.09.2011, 14:23 +0200 schrieb Eric Dumazet:
> > Its a plain bug, please submit a formal patch.
> > 
> > Probably not noticed because timer is set to more than 24 days.
> > 
> 
> okay. I think a similar problem exists for sys_truncate() in ia32 layer
> on x86_64:
> 
> the ia32 syscall is directly wired to sys_truncate(char *, long).
> 
> signed long will use %rbx on x86_64 and %ebx on x86.
> 
> call sys_truncate on x86_64 from x86 userspace will handle length
> 0xffffffff not as -1.
> 
> maybe an easy fix would be to change long to unsigned long for
> sys_truncate(), like sys_ftruncate(). what do you think?

I think you should take a look at fs/compat.c



