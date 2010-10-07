Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab0JGKse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 06:48:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52453 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0JGKsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 06:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BVZ7+FU+9egDezGGfipY1JJGlwSKWbasSNq27nBDjN61eJUzQG/6ISJdvF7ippdWpn
         UUQOl08XpdtnWKEgJBATbgMkRkqjZhjXIaee5vdvowWtjrxy4MgMT4VgIVm9XBJvLTlN
         SHAeMYeVuvUbzVcUUohZiGuK2aTdxnEX/uqW0=
MIME-Version: 1.0
In-Reply-To: <1286407891.32241.21.camel@Joe-Laptop>
References: <1286407891.32241.21.camel@Joe-Laptop>
Date: Thu, 7 Oct 2010 16:18:32 +0530
X-Google-Sender-Auth: rQ7taqY0fkP5RW_h5fTQpGHeP9k
Message-ID: <AANLkTimie7QnHGoP2UwvqfqETiBUJ42xmB2YM7OAJXdq@mail.gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Warn on non-executable files
 created with non 100644 file permissions
From: Rabin Vincent <rabin@rab.in>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 5:01 AM, Joe Perches <joe@perches.com> wrote:
> +               if ($rawline =~ /^ create mode (\d+) ([\w\.\/\-]+)$/) {
> +                       my $mode = $1;
> +                       my $file = $2;
> +                       if ($mode ne "100644" && !($file =~ /\.(sh|pl|py|awk)$/)) {
> +                               WARN("FILE '$file' should probably use file permission 100644 not $mode\n" . $herecurr);
> +                       }
> +               }
> +

There's a vaguely similar patch already in -mm.  That one also handles mode
changes and doesn't require the presence of the diff summary.  Have a look in
case you missed it, maybe it does most of what you want and you can base
something on that:

http://userweb.kernel.org/~akpm/mmotm/broken-out/checkpatch-check-for-incorrect-permissions.patch
