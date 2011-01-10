Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1AJMMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:12:33 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:43858 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1AJMMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:12:31 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Sam Ravnborg'" <sam@ravnborg.org>
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn> <20110106075553.GC15914@linux-sh.org> <023601cbaef7$850f2af0$8f2d80d0$@mprc.pku.edu.cn> <20110108072053.GA10552@merkur.ravnborg.org> <023c01cbaf24$85a99cc0$90fcd640$@mprc.pku.edu.cn> <20110108114826.GA7915@merkur.ravnborg.org>
In-Reply-To: <20110108114826.GA7915@merkur.ravnborg.org>
Subject: RE: [PATCHv1 01/12] unicore32 core architecture: build	infrastructure
Date: Mon, 10 Jan 2011 20:12:18 +0800
Message-ID: <002201cbb0bf$a20e9d60$e62bd820$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEfSwmwFZxtPXz+EiWqnhCTy4B4ZAEbQqKvAoaCX2cCTHiU4QIu/uxyAMPdVASU291zgA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sam Ravnborg [mailto:sam@ravnborg.org]
> Sent: Saturday, January 08, 2011 7:48 PM
> To: Guan Xuetao
> Cc: 'Paul Mundt'; linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
> 
> > > > +textofs-y	:= 0x00408000
> > > > +
> > > > +# The byte offset of the kernel image in RAM from the start of RAM.
> > > > +TEXT_OFFSET := $(textofs-y)
> > >
> > > If you are going to have different TEXT_OFFSET's then I suggest to move
> > > this to KConfig as an "hex "Text offset" config option.
> > > You can set default values dependign on BSP etc.
> > There is no different TEXT_OFFSET.
> >
> > >
> > > Also defiing stuff here just to export it for use in boot/
> > > has always looked like a strange concept - but many archs do so today.
> > > You do not export TEXT_OFFSET but I guess this is a bug?
> > I need TEXT_OFFSET for kernel/ and boot/, so export it.
> 
> I would suggest to move this to you Kconfig file.
> something like this:
> 
> # The byte offset of the kernel image in RAM from the start of RAM
> config UNICORE32_TEXT_OFFSET
> 	hex
> 	default 0x00408000
> 
> Then you have the symbol available as CONFIG_UNICORE32_TEXT_OFFSET
> both in your Makefiles and in your source files.
Thanks.
Because TEXT_OFFSET is not changed in different machines or in configuration time,
I move it into mach-spec memory.h and rename it KERNEL_IMAGE_START.

Guan Xuetao

