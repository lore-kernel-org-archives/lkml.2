Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0EFGrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:47:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50071 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0EFGrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LAm5EUH9U7y+ocXiOPdd0Ja8GhVEb45xlDquw+mlb4HSoahEZjvgp7BoP38z3LLLCf
         ZJVldke8fXYPcWauAu28W+/w444ePiDS+zLaeQBX5ISDNh63+DJWwD+67PuDBqMqPpz0
         STeW6yoKqt9CFch71XDSn29ogUR6bLJQYXKyc=
MIME-Version: 1.0
In-Reply-To: <1273096160.23208.35.camel@mulgrave.site>
References: <1273096160.23208.35.camel@mulgrave.site>
Date: Thu, 6 May 2010 08:47:39 +0200
X-Google-Sender-Auth: 99bf05a63f417d78
Message-ID: <p2x10f740e81005052347x9430657fua98b8982e860bd2d@mail.gmail.com>
Subject: Re: kbuild: fixing the select problem
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 23:49, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> [Sam: I know you don't maintain kbuild anymore, but since you have the
> most experience, if you could find time to comment, I'd be grateful]
>
> The select problem is that the kbuild select directive will turn a
> symbol on without reference to its dependencies.  This, in turn, means
> that either selected symbols must select their dependencies, or that
> people using select have to be aware of the selected symbol's dependency
> and build those dependencies into their symbol (leading to duplication
> and the possibility of getting the dependencies out of sync).  We use
> select for the scsi transport classes, so we run into this problem in
> SCSI quite a lot.
>
> I think the correct fix is to make a symbol that selects another symbol
> automatically inherit all of the selected symbol's dependencies.

What if there's a good reason the selected symbol has this dependency?
E.g. it depends on a critical feature not available? Like CONFIG_HAS_IOMEM?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
