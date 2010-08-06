Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250Ab0HFCSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:18:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44881 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab0HFCSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CF/nfbBrTb3im5VcDcfttKwI/BlitLi21lF2oJkVMdNrZb8kpOKuBokUP6abrF0CXX
         ZzESWsP/9JpqmEzjZWbINRUw6QOlsl5y+oCbj+lvMrBZixzhEYN513+GCj7KX5E+J+2R
         PUiYF8txeHq/N1KUpyN7Zen5fLIVDOYY+67uw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 2/4] module linker script: coalesce function and data sections
Date: Fri, 6 Aug 2010 04:18:06 +0200
User-Agent: KMail/1.8.2
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, linux-arch@vger.kernel.org,
        Parisc List <linux-parisc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matt Fleming <matt@console-pimps.org>, Arnd Bergmann <arnd@arndb.de>,
        Anders Kaseorg <andersk@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com> <1280360876-2571-3-git-send-email-vda.linux@googlemail.com> <4C581DEE.8080205@suse.cz>
In-Reply-To: <4C581DEE.8080205@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008060418.06363.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 August 2010 15:47, Michal Marek wrote:
> On 29.7.2010 01:47, Denys Vlasenko wrote:
> >  SECTIONS {
> > +
> > +	/* Coalesce sections produced by gcc -ffunction-sections */
> > +	.text   0 : AT(0) { *(.text .text.[A-Za-z0-9_$^]*) }
> > +
> > +	/* Coalesce sections produced by gcc -fdata-sections */
> > +	.rodata 0 : AT(0) { *(.rodata .rodata.[A-Za-z0-9_$^]*) }
> > +	.data   0 : AT(0) { *(.data .data.[A-Za-z0-9_$^]*) }
> > +	.bss    0 : AT(0) { *(.bss .bss.[A-Za-z0-9_$^]*) }
> > +
> >  	/DISCARD/ : { *(.discard) }
> >  }
> 
> I'm now getting
> 
> ld:/home/mmarek/linux-2.6/scripts/module-common.lds:23: ignoring invalid
> character `^' in script
> ld:/home/mmarek/linux-2.6/scripts/module-common.lds:26: ignoring invalid
> character `^' in script
> ld:/home/mmarek/linux-2.6/scripts/module-common.lds:27: ignoring invalid
> character `^' in script
> ld:/home/mmarek/linux-2.6/scripts/module-common.lds:28: ignoring invalid
> character `^' in script
> 
> when linking modules and a similar warning when linking vmlinux (caused
> by the next patch in series). I tried writing the carets as \^, but that
> doesn't help at all...

Yep, I can confirm it. The binutils fix to allow caret might be trivial,
and will allow us to use much better pattern: [^.]*

I created a Fedora bug for it:

https://bugzilla.redhat.com/show_bug.cgi?id=621742

So far, please remove these three patches from kbuild tree.

(I see that modpost patch is in Linus tree. Thanks!)

-- 
vda
