Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab1E0Dln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:41:43 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:41845 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab1E0Dl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:41:28 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <greg@kroah.com>, "'Sam Ravnborg'" <sam@ravnborg.org>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <48ec206f634cad2019c92eef7ba1a87566c743fe.1306408804.git.gxt@mprc.pku.edu.cn> <201105261445.01390.arnd@arndb.de>
In-Reply-To: <201105261445.01390.arnd@arndb.de>
Subject: RE: [PATCH 6/6] unicore32: using generic-y format for one line asm-generic files
Date: Fri, 27 May 2011 11:24:03 +0800
Message-ID: <005a01cc1c1d$88f727b0$9ae57710$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIcsKU1gucno1VE3ekXHpcmNwpJlQKC24gMArSiI+iT1RnSwA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, May 26, 2011 8:45 PM
> To: GuanXuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; greg@kroah.com; Sam Ravnborg
> Subject: Re: [PATCH 6/6] unicore32: using generic-y format for one line asm-generic files
> 
> On Thursday 26 May 2011, GuanXuetao wrote:
> > From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >
> > see commit from Sam Ravnborg <d8ecc5cd8e227bc318513b5306ae88a474b8886d>
> >   kbuild: asm-generic support
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > ---
> >  arch/unicore32/Makefile           |   35 ----------------------
> >  arch/unicore32/include/asm/Kbuild |   59 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 59 insertions(+), 35 deletions(-)
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> This reminds me that I should do the same for ARM and maybe some others.

There is a potential problem.
When I add stat.h with generic-y method, a file is generated in arch/*/include/generated/asm/ dir.
And then,  a patch for old-abi is applied, which will restore an old stat.h in arch/*/include/asm/ dir.
Without removing the line in arch/*/include/asm/Kbuild, two files exist in the meantime.
It works, depending on the order in LINUXINCLUDE, and (perhaps) the handling order in gcc.
So, a check and warning mechanism should be provided to clear up the confusion.

Guan Xuetao

