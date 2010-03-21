Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0CULIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 07:08:14 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:43495 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0CULIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 07:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bpB0OZj8xuvffc/7pJMwvei8kCSEjucG+Wy36hSKP1yhKamFG7owwhYpkqxAwwzpSp
         1tch5ZiQckglEpUW2FRBN9QsJDWC259FQ2HizXOgkosGLe89v/09l4nkHrV7XlKCayhH
         8adiRSqdMWSHPdP/g4IeygoeN9wbRPxeGWvjI=
Date: Sun, 21 Mar 2010 14:07:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
       penberg@cs.helsinki.fi, pavel@ucw.cz, harvey.harrison@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: strip_whitespace.pl
Message-ID: <20100321110758.GL5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, harvey.harrison@gmail.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1269098051-6594-1-git-send-email-lindley@coyote.org> <20100320162426.GB28881@bicker> <4BA5204C.9050208@coyote.org> <20100321105541.GK5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100321105541.GK5331@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 01:55:42PM +0300, Dan Carpenter wrote:
> I've written a new script called strip_whitespace.pl (included).
> 
> One bug is that, if you split or unsplit a string literal that
> confuses it.  Otherwise it seems to work.
> 
> strip_whitespace.pl drivers/staging/winbond/reg.c > before
> apply patch
> strip_whitespace.pl drivers/staging/winbond/reg.c > after
> 
> `diff before after`.  If they are the same then resend the patch.

On further reflection your new patch looks fine, if you combine the two.  
But next time could you use my script?

Acked-by:  Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

> 
> regards,
> dan carpenter
> 
> #!/usr/bin/perl
> 
> use strict;
> 
> my $file = shift();
> open FILE, "<$file";
> my $txt = do { local $/;  <FILE> };
> 
> # strip C99 comments
> $txt =~ s/\/\/.*//g;
> # strip newlines
> $txt =~ s/\n//g;
> # strip remaining comments
> $txt =~ s/\/\*.*?\*\///g;
> # strip tabs
> $txt =~ s/\t//g;
> # strip spaces
> $txt =~ s/ //g;
> # add newlines again
> $txt =~ s/;/;\n/g;
> 
> print "$txt\n";
