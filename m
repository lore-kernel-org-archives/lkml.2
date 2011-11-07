Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1KGUVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:21:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50027 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1KGUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:21:13 -0500
Date: Tue, 8 Nov 2011 00:19:08 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Valdis.Kletnieks@vt.edu
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] proc: restrict access to /proc/interrupts
Message-ID: <20111107201908.GA5827@albatros>
References: <20111107174522.GA2317@albatros>
 <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros>
 <4EB82F08.8060209@zytor.com>
 <14202.1320696659@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14202.1320696659@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 15:10 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 07 Nov 2011 11:18:32 PST, "H. Peter Anvin" said:
> 
> > I would like to propose that we add a mount option to procfs, and
> > possibly sysfs, called, say, admingrp.  These kinds of files then get
> > restricted to the admingrp (defaulting to gid 0 if no admingrp is
> > provided).  Historically on Unix there has been a group of people
> > (usually "adm", but sometimes "log") who are allowed to read (but not
> > write) the log files, which also contains potentially sensitive information.
> 
> Probably should be a two part - mount with 'gid=NNN', and then a
> perm=027 or whatever, to be treated similar to a umask.  So 027
> would allow root to do anything, would disable write for the gid= group,
> and turn it off completely for others.  Less paranoid sites could mount
> it with perm=002.
> 
> Does that cover most of the use cases?

At the time of Linux 2.0-2.4 in Owl patch there was a plain on/off
configure option - 022 / 066 umask.  Currently procfs restriction is
implemented in Grsecurity with the same all-or-nothing approach.
Brad Spengler told me that there were no user complains about the lack of
flexibility :-)   So, I agree that we don't need anything more complex.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
