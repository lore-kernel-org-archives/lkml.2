Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2IYJN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:13:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53105 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab2IYJN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:13:28 -0400
Date: Tue, 25 Sep 2012 11:13:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Franklin Wei <frankhwei536@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: arch/x86/lib/inat.c Error
Message-ID: <20120925091324.GC1247@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Franklin Wei <frankhwei536@gmail.com>, linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@redhat.com>
References: <CAEMuUziMGAM4UOeOGWwG9jiceU9K7NSzqbryMxHwFDfmOfqQdA@mail.gmail.com>
 <20120924075957.GA5151@liondog.tnic>
 <CAEMuUzjbudxmGOZqB2HBLNa7p=aRqdiNKNXZLRV7c9yKPJ7TxQ@mail.gmail.com>
 <50610602.5050003@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50610602.5050003@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:16:50PM -0700, Randy Dunlap wrote:
> >> That's because all those _tables thingies are included from a
> >> "inat-tables.c" in the same directory but it somehow doesn't get
> >> included?!
> >>
> >> Can we get your .config pls? Also, you're doing a "normal" kernel build
> >> on the command line, right?
> >>
> >> Thanks.
> 
> 
> Your config builds OK for me.
> Do you see this line in your build output before inat.c is built?
> 
> 
>   GEN     arch/x86/lib/inat-tables.c

Yeah, this looks like stale files from the build or similar are not
being properly cleaned. Franklin, do the following:

$ cp .config /tmp/
$ make mrproper
$ cp /tmp/.config .
$ make oldconfig
$ make -j<num_cpus + 1>

to verify that a clean build actually fixes your issue.

Thanks.

-- 
Regards/Gruss,
    Boris.
