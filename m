Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1CBIFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:05:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55945 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1CBIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RzRaWr4evgxsOfp6TAbqCDSihDOLL/sJc1nud/uuLgtADyMzV9YhPY/5eHRWaUU8D3
         0BBiDIxiR+cTpVSk8KRkoAQmdFN+wrNbErXYzfwzi2TbnAfKZ2hM/GHbhT4bnP6Qyxs1
         YqDI8T9yA9X5xy1mqOj2Xqy3217I/LSL8PK/Y=
Date: Wed, 2 Mar 2011 10:05:38 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org, jj@chaosbits.net,
        arnd@arndb.de
Subject: Re: [PATCH] kstrto*: converting strings to integers done
 (hopefully) right
Message-ID: <20110302080538.GA4811@p183.telecom.by>
References: <20110226124708.GA29242@p183.telecom.by>
 <20110301152455.995eb661.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301152455.995eb661.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 03:24:55PM -0800, Andrew Morton wrote:
> On Sat, 26 Feb 2011 14:47:08 +0200
> Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > Use kstrto*() in code today!
> 
> If you can stomach perl, please prepare a checkpatch patch which alerts
> people to the new regime.

Ehh, checkpatch was updated.
	scripts/checkpatch.pl        |    4

> >  Let's merge this into mainline, so I can send individual patches
> >  to subsystem maintainers. Whole tree is already converted locally.
> 
> Talk to us about the tighter checking.  There's a risk here that
> current userspace which "works" will cease to work if we add additional
> input checking. Even if that userspace was broken and
> just-happened-to-work, adding additional checks might cause disruption?

What strict_ family of functions errorneously does is to not check for
integer overflow in the result, so it'll happily eat a very long string
full of _valid_ digits: "0xffffffffffffffffffffffffffffffffffffffffffff"
will be converted to unsigned long even if it doesn't fit.
But people don't use such long strings, so the risk is low.

Also, kstrto*() allow to use leading '+' for positive values,
which is not restriction.

The rest should be the same.
