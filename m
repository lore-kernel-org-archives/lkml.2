Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2IYWau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:30:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60104 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2IYWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120925091324.GC1247@liondog.tnic>
References: <CAEMuUziMGAM4UOeOGWwG9jiceU9K7NSzqbryMxHwFDfmOfqQdA@mail.gmail.com>
	<20120924075957.GA5151@liondog.tnic>
	<CAEMuUzjbudxmGOZqB2HBLNa7p=aRqdiNKNXZLRV7c9yKPJ7TxQ@mail.gmail.com>
	<50610602.5050003@xenotime.net>
	<20120925091324.GC1247@liondog.tnic>
Date: Tue, 25 Sep 2012 18:30:47 -0400
Message-ID: <CAEMuUzgMELEqYQTt98ERoUHV1MrCcg4FnMDSLHzYOT+uY_uTPg@mail.gmail.com>
Subject: Re: arch/x86/lib/inat.c Error
From: Franklin Wei <frankhwei536@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Franklin Wei <frankhwei536@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found something:
My inat-tables.c is blank!
Going to get the source from Git and try again.
Thanks for the help!

On 9/25/12, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Sep 24, 2012 at 06:16:50PM -0700, Randy Dunlap wrote:
>> >> That's because all those _tables thingies are included from a
>> >> "inat-tables.c" in the same directory but it somehow doesn't get
>> >> included?!
>> >>
>> >> Can we get your .config pls? Also, you're doing a "normal" kernel
>> >> build
>> >> on the command line, right?
>> >>
>> >> Thanks.
>>
>>
>> Your config builds OK for me.
>> Do you see this line in your build output before inat.c is built?
>>
>>
>>   GEN     arch/x86/lib/inat-tables.c
>
> Yeah, this looks like stale files from the build or similar are not
> being properly cleaned. Franklin, do the following:
>
> $ cp .config /tmp/
> $ make mrproper
> $ cp /tmp/.config .
> $ make oldconfig
> $ make -j<num_cpus + 1>
>
> to verify that a clean build actually fixes your issue.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
