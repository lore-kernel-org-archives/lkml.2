Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0GZBbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 21:31:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0GZBbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 21:31:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fUZsyWfA88oSlGtzSSMU6/dayLX4VaBi24y55losSHERDBymM4c0ry23BUbqvkvznI
         yxyD1zpFNaDdkUtUuMfHtK2B1d3OkZYfRCE2SAKYBiHt/KZewG70WVM1ONGrP/TVzvrB
         9Hn8lptxNhqy64PNxwtODnb0k08AbJSN6ygyk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Date: Mon, 26 Jul 2010 03:31:34 +0200
User-Agent: KMail/1.8.2
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
References: <201007181703.17022.vda.linux@googlemail.com> <20100723203543.GB27288@merkur.ravnborg.org>
In-Reply-To: <20100723203543.GB27288@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007260331.34372.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Friday 23 July 2010 22:35, Sam Ravnborg wrote:
> > 
> > Then, in order to also garbage-collect the sections, I added
> > 
> > LDFLAGS_vmlinux += --gc-sections
> > 
> > in top-level Makefile.
> > 
> > This requires the additional patch (linux-2.6.35-rc4-fsgs.patch)
> > which adds KEEP(section) directives to kernel linker stripts.
> > Otherwise, linker will discard some crucial sections.
> > 
> 
> Changelog does not address why you need:
> 
>      -Map $@.ldmap
> 
> and what effect they have.

I didn't plan to push the last step (--gc-sections) to mainline yet.
Thus the patch has debugging stuff in it.


> And it is obvious that some archs should consolidate a little more from
> asm-generic/vmlinux.lds.h.
> But that said this patch looks much better than the initial versions posted.
> 
> How do you determine which sections needs the KEEP()?
> Worth documenting for future when we add new sections.

No problem, I will be adding comments at every KEEP() why it's needed.

-- 
vda
