Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1FWREY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:04:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40081 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab1FWREV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ehc95msy/DSspmuavPvApja8lc2DYktNIctM5zzSHGEgg5lvnm5SKCPGSnjY+9L0PW
         nKK4IaNVp3cLK7pwzuugr9MfSlh8wkENGrvJZYPeSHRQWLF9rW5o2h+ZTd9B8aDLs4SW
         FaKK1+JovOBL4UNbIxAzcX+H44Al+KlEB0PWc=
MIME-Version: 1.0
In-Reply-To: <20110622063441.GA1740@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
Date: Thu, 23 Jun 2011 19:04:19 +0200
Message-ID: <BANLkTimci1ZDZFnO5n0H3ADCEaQStwLkdw@mail.gmail.com>
Subject: Re: __packed vs. __attribute__((packed)) in kernel headers
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 8:34 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> A recent commit 3627924acf70a changed __attribute__ ((packed)) to
> __packed in some UBI headers. This breaks the build of busybox:
>
>  CC      miscutils/ubi_attach_detach.o
> In file included from miscutils/ubi_attach_detach.c:27:0:
> /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
> /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> /usr/include/mtd/ubi-user.h:372:3: error: conflicting types for ‘__packed’
> /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> ...
>
> But this kind of change is suggested by checkpatch.pl:
>  WARN("__packed is preferred over __attribute__((packed))\n
>
> One possible solution would be to let the "scripts/headers_install.pl"
> script automatically substitute __packed with __attribute__((packed)):
>
> diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> index efb3be1..e0dc065 100644
> --- a/scripts/headers_install.pl
> +++ b/scripts/headers_install.pl
> @@ -35,6 +35,7 @@ foreach my $file (@files) {
>                $line =~ s/([\s(])__iomem\s/$1/g;
>                $line =~ s/\s__attribute_const__\s/ /g;
>                $line =~ s/\s__attribute_const__$//g;
> +               $line =~ s/\s__packed/__attribute__((packed))/g;
>                $line =~ s/^#include <linux\/compiler.h>//;
>                $line =~ s/(^|\s)(inline)\b/$1__$2__/g;
>                $line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
>
> Any thoughts?
>

Hmm, this introduces a new error source.
Whenever we change the definition of __packed we have to
adjust headers_install.pl too.

-- 
Thanks,
//richard
