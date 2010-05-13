Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0EMRee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:34:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55713 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0EMRec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Y6hB35m7HvhWSfxV4oVk0VZejl6dKLUM9O1WOCcKTqP6dwoLkBPehB4ssrBKYkb5HO
         IexQ8NQl0RBlxp5MyLRXe+0eXw3dMmBDwbaH5FI6GSjMJ1Si3oO6IWzGGpFitu+OarED
         OdUwSyAQCrKqTAiaQrpRHYgb/wv15N5jb/Nx4=
Date: Thu, 13 May 2010 14:34:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: perf: relative path to source for perf probe?
Message-ID: <20100513173426.GK19192@ghostprotocols.net>
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
 <20100513145826.GJ30926@ghostprotocols.net>
 <AANLkTin1w6OoS_6qzMqIizBxOGiV7DXJ936-hdHSFCD8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1w6OoS_6qzMqIizBxOGiV7DXJ936-hdHSFCD8@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 13, 2010 at 06:01:10PM +0200, Chase Douglas escreveu:
> On Thu, May 13, 2010 at 4:58 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Look in tools/perf/util/symbol.c, these variables are the ones tools use
> > to govern how the symbol system work wrt finding vmlinux:
> >
> > symbol_conf.use_vmlinux_path
> > symbol_conf.vmlinux_name
> >
> > In addition to this it will use what is in ~/.debug/ if it has a
> > build-id in the perf.data header.
> >
> > The changes for support kvm also touched this and allow for some
> > prefixing to look for guest symbols, generalizing that to make guest
> > kernel vmlinux + modules relative location be reused to look for
> > relative location for host kernel vmlinux + modules seems the way to go.
> 
> After reading this some more, I think we are talking about two
> different things. I think your notes above are referring to locating
> the vmlinux image and other debug symbols. This seems to work fine for
> me using the -k flag.

What about finding the associated modules?

> However, I'm encountering an issue where the source code location
> isn't found. I think this is fairly specific to the probe command of
> perf, which is fairly new, so maybe it's missing the same level of
> support that the symbol finding code has?

Annotation needs it, in top, report, too.

But probably (haven't looked at the sources) the way to specify it will
be different, since we rely on objdump to do the disassembly, we need to
inform it where the sources are, but look at the source of all this, the
relevant DWARF tags:

 <0><b>: Abbrev Number: 1 (DW_TAG_compile_unit)
    < c>   DW_AT_stmt_list   : 0x0      
    <10>   DW_AT_ranges      : 0x0      
    <14>   DW_AT_name        : /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/kernel/head_64.S       
    <57>   DW_AT_comp_dir    : /home/acme_unencrypted/git/build/v2.6.34-rc6-

- Arnaldo
