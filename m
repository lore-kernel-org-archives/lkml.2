Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1FVQyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:54:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab1FVQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q5w5Zhn7WD7MM6T5+aLBNbQYoreWKNYoACXrgHuAZBfCS134N0J0uyAtNgJISf4Lnl
         DKauZYwY3liDWnaoH8WZbx3zyfJVt13VUFwiSPblealMHKWZmXdytiTKC+E8nqkB9ybz
         Ad3WjAW7DjNqfQsP9HEMTJaQZyApRzDdB6CRs=
Date: Wed, 22 Jun 2011 20:53:55 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110622165355.GB11803@albatros>
References: <20110622095341.GA3353@albatros>
 <1308760683.10423.16.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308760683.10423.16.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 09:38 -0700, Joe Perches wrote:
> On Wed, 2011-06-22 at 13:53 +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().
> 
> []
> 
> > diff --git a/kernel/printk.c b/kernel/printk.c
> []
> > +static void emit_log_char_escaped(char c)
> > +{
> > +	char buffer[8];
> > +	int i, len;
> > +
> > +	if ((c >= ' ' && c < 127) || c == '\n')
> 
> 	if (isprint(c))

#define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)

It slightly differs from what I've written.  It (1) lacks '\n', (2)
passes non-ASCII symbols.  How would non-ASCII symbols look like if
terminal doesn't support it?  (I don't know, merely asking).


But if >159 (the number got from _ctype[]) is not an issue then
(isprint(c) || (c == '\n')) looks really better.

> Why not add this to emit_log_char?

No real need, but someone may want to explicitly bypass the check, it
should use emit_log_char() instead of emit_log_char_escaped().


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
