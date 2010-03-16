Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0CPWmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:42:39 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61657 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0CPWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=jVnkaF9AAmAkwBKhtqMIWOQGjxsZo/T2yxFqcaQXcmP9UjuXIKwBncwaseRrqLErNK
         sdk3UifFNSqHA7RJQzO9gg0yDufYCa6mhRu95br3mIptdIptJVE29UP3cqOAVMnbj8Zw
         at4qGcNuQTDMajfPvIOolHRJvyulKHsc0meO0=
From: "Will L Givens" <wlgivens@gmail.com>
To: "'Michael Cree'" <mcree@orcon.net.nz>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>,
       "'Matt Turner'" <mattst88@gmail.com>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com> <20100316182534.GA818@ds20.borg.net> <006e01cac54e$dd6b7b10$98427130$@com> <b4198de61003161439s1fc43b75v45595b475053b3d@mail.gmail.com> <4AB85842-79DF-412F-833C-4B784353A1F5@orcon.net.nz>
In-Reply-To: <4AB85842-79DF-412F-833C-4B784353A1F5@orcon.net.nz>
Subject: RE: Will's kernel compilation error
Date: Tue, 16 Mar 2010 17:42:02 -0500
Message-ID: <007801cac559$e798c330$b6ca4990$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrFVOMCxI6+4x3lTZG508JIlaBQvAAA5iAA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The patch is not suitable, IMHO, for the kernel as it stands.  Some of
> us prefer the small-data model as we must boot off a slow medium that
> is supported by SRM.  Using large-data results in a larger code size.
> 
> It would be nice if the build system could detect the need for the
> large-data model before compilation but I can't see how to do that
> without actually compiling the kernel.
> 
> Therefore I suggest a kernel config item be added to optionally remove
> the -msmall-data compiler option for those who are building kernels
> with data areas greater than 64kB.  I'll drum up a patch later today.
> 
> Cheers
> Michael.

Actually I added several modules into the kernel (raid0/1, router protocols,
and subsystem for TV cards)and it was about 100KB smaller. If push came to
shove, you could simply strip the symbols from the kernel (strip -s vmlinux)
and modules and use gzip -9 (done it in the past and it works fine). Another
thing, how could 2MB make that big of a different on boot time? I used to
use an old 50MB AT drive on my UP2000 (OS installed to 2 IDE drives via a
non-bootable Promise card)and it read at 1MB/s. So, at worst, you're talking
about maybe a 1 to 2 second difference?

Just tested it on my currently modules, went from 35MB to 19MB... not too
shabby.

