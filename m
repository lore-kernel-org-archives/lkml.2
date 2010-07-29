Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0G2BYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 21:24:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58045 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0G2BYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 21:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YYGZm+LhAEq/P7nKlHgasoSA0345+JalCMjYntov3q894v5FB6E116k+7gLoSqV5S/
         ap3ntzXfnAUMAhAuzZOEgXa6j/kRhRu5Z1JvO/Y7H/UGRKMWknQRAgnswqP9HwxMDOMn
         n7Gd5vcvcZOgmt4BHHXg2Vwq6jNfHO/Tvzn7A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/4] module linker script: coalesce function and data sections
Date: Thu, 29 Jul 2010 03:24:36 +0200
User-Agent: KMail/1.8.2
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-arch@vger.kernel.org, Parisc List <linux-parisc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matt Fleming <matt@console-pimps.org>, Arnd Bergmann <arnd@arndb.de>,
        Anders Kaseorg <andersk@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1280360876-2571-3-git-send-email-vda.linux@googlemail.com> <1280360876-2571-1-git-send-email-vda.linux@googlemail.com> <29025.1280363105@redhat.com>
In-Reply-To: <29025.1280363105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007290324.36745.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 July 2010 02:25, David Howells wrote:
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
> > +	.data   0 : AT(0) { *(.data .data.[A-Za-z0-9_$^]*) }
> > +	.bss    0 : AT(0) { *(.bss .bss.[A-Za-z0-9_$^]*) }
> 
> What about .sdata and .sbss sections produced by arches that support small
> data sections?

linker groups all similarly-named input sections into one output section
with the same name, if the name does not match any rule in the linker
script.

Basically, it should work as if there is a rule:

.sbss    0 : AT(0) { *(.sbss) }

-- 
vda
