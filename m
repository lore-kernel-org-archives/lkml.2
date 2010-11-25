Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0KYGag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:30:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39778 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0KYGaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=U0fqcC/LJyp/SUyaFCS2RMHNb8OELKNDP9TJiFWHjfc2EoKeCW+w+Hhk5n+IN2PPBd
         LOzR7a/HYfrG6H+7Wrnhee6QKI7EblhFFx1RHH8oyeJi1EZUFaNYcHIVdaOW0LomI4yN
         11J9qgg1XlgdmQQGyP9uTttZB9wC+jJ3jRTg4=
Date: Thu, 25 Nov 2010 07:30:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jesper Juhl <jj@chaosbits.net>, Rakib Mullick <rakib.mullick@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
Message-ID: <20101125073029.6ede17db@nowhere>
In-Reply-To: <25439.1290658067@localhost>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
	<alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
	<25439.1290658067@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 24 Nov 2010 23:07:47 -0500,
Valdis.Kletnieks@vt.edu a écrit :

> On Wed, 24 Nov 2010 10:57:10 +0100, Jesper Juhl said:
> 
> > On Wed, 24 Nov 2010, Rakib Mullick wrote:
> 
> > > diff --git a/arch/x86/kernel/dumpstack.c
> > > b/arch/x86/kernel/dumpstack.c index 8474c99..fc5a253 100644
> > > --- a/arch/x86/kernel/dumpstack.c
> > > +++ b/arch/x86/kernel/dumpstack.c
> > > @@ -197,10 +197,10 @@ void show_stack(struct task_struct *task,
> > > unsigned long *sp)
> > >   */
> > >  void dump_stack(void)
> > >  {
> > > -	unsigned long bp = 0;
> > >  	unsigned long stack;
> > > 
> > >  #ifdef CONFIG_FRAME_POINTER
> > > +	unsigned long bp = 0;
> > >  	if (!bp)
> > >  		get_bp(bp);
> > >  #endif
> > 
> > So, now the bp variable does not exist at all if
> > CONFIG_FRAME_POINTER is not defined.
> > That's going to make this line :
> > 
> >           show_trace(NULL, NULL, &stack, bp);
> > 
> > found further down in the dump_stack() function, quite unhappy.
> 
> OK, I'll bite.  Why does the original say 'unsigned long bp = 0;' and
> then turns around and has an 'if (!bp)' check?  Why is the
> conditional there?

The original check was indeed not necessary. But now the whole block
should be removed anyway.
