Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1EXOt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:49:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62661 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab1EXOt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m362OMyM2VQlgQhQzQu5hrRWO586VCkyoTbrm/169s18tQVPHlU9B3bQg0NqZHWb8/
         XCJi+jyMR7X0ZylAMPcDXokPO6+L1s0PI+pgy9Qk58YF+9sRe8ab3IXYgJleTN90HZld
         gSWK5tdggirPOWbshyvbLjh5iU/KLq7jb3vbQ=
MIME-Version: 1.0
In-Reply-To: <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
	<A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
Date: Tue, 24 May 2011 10:49:26 -0400
X-Google-Sender-Auth: FxNYDXHDqheGNAySxWTEOBhZ9B0
Message-ID: <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
Subject: Re: UNIX Compatibility
From: Richard Yao <ryao@ic.sunysb.edu>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ted,

First off, I was wrong about the system call codes. I just checked my
reference and the difference between Linux and UNIX System V that I
meant to cite involved the system error codes. At the moment, I do not
know anything about the compatibility of the system call codes.

With that out of the way, I am under the impression that the Linux
kernel code is in some way incompatible with the Single Unix
Specification (i.e. the thing required for an OS to be certified as
being UNIX). So far, the only kernel code of which I am aware that
could possibly be incompatible is code involving error codes, but
after reading your email, I realize that I am not sure if having those
match the UNIX System V error is a requirement for the specification.
I have always heard that Linux was almost compatible with UNIX, but
not quite compatible; yet no one ever seems to enumerate the reasons
for that. I know that the GNU userland that typically accompanies the
Linux kernel in Linux distributions is not UNIX compatible (e.g.
blocks are not 512 bytes).

I would like to know if there is anything in the kernel code itself
that would need to change for people to say that Linux is a UNIX
kernel minus the external factors (i.e. a UNIX userland and
certification) needed to be an official UNIX kernel. If there are any
long standing differences, now would be a good time to discuss
resolving them considering the proposed Linux 3.0 change.

By the way, with regard to the error codes, Groklaw has an article
enumerating the differences from UNIX System V:

http://www.groklaw.net/articlebasic.php?story=20040221192536920

It seems Linus Torvalds wanted to use the UNIX System V call codes
when he was working on Linux 0.0.1, but he lacked a reference at the
time, so he only got them partially right. Considering that the error
codes were originally intended to be compatible with UNIX System V, it
might be worth changing them to match. The Linux 3.0 change would
probably be a good time for this.

Yours truly,
Richard Yao

On Tue, May 24, 2011 at 9:06 AM, Theodore Tso <tytso@mit.edu> wrote:
>
> On May 24, 2011, at 7:49 AM, Richard Yao wrote:
>
>> I know that the system call codes used by Linux are not 100% UNIX
>> compatible. Is there anything else in the kernel that is not UNIX
>> compatible? Would modifying these things for UNIX compatibility break
>> anything in userland provided that it is recompiled against the
>> modified sources?
>
> What do you mean by "UNIX compatible?"  API compatibility?
> ABI compatibility?   Which Unix?  Solaris and HPUX and AIX
> are systems which are allowed to use the Unix(tm) trademark,
> but them are not compatible with each other.
>
> So the question you are asking is not well defined.
>
> Also, why are you asking it?   What problem are you trying to solve?
> At this point, Linux is running on far more servers than any of the
> Legacy Unix systems out there, and the ones which are still in
> development (i.e., Solaris and AIX) are have recently been worrying
> about adding Linux compatibility layers (usually at the API level).
>
> -- Ted
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
