Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0IQPdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:33:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:60992 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab0IQPde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:33:34 -0400
Message-ID: <4C938A4B.4030601@suse.cz>
Date: Fri, 17 Sep 2010 17:33:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: matt mooney <mfm@muteddisk.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Documentation/kbuild: major edit of modules.txt sections
 1-4
References: <1284628230-910-1-git-send-email-mfm@muteddisk.com>
In-Reply-To: <1284628230-910-1-git-send-email-mfm@muteddisk.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.9.2010 11:10, matt mooney wrote:
> Omit needless words and sentences; reorganize and tighten sentence structure;
> swap sections 2.2 and 2.3 for a more logical flow; and cleanup some of the
> inconsistency with the margin width.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
> A couple of notes: 
>     I chose to use the environment variable $PWD in the examples for both the commandline
>     and Makefile; however, I was wondering if I should have set PWD in the Makefile and
>     used $(PWD) instead.

I'd rather keep the example Makefile minimalistic.


> Also, the $@ variable was removed from the 'make' command within
>     the Makefile. I did not understand the purpose of this for building kernel modules and
>     it would break my test build.

$@ is the name of the target, so in
		all::
			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
this translates to '$(MAKE) -C $(KERNELDIR) M=`pwd` all' which is the
default. So with your change it does the same, but I'm surprised that
the $@ didn't work for you.

[...]
> -	$KDIR refers to the path to the kernel source top-level directory
> +	$KDIR is the path to the kernel source directory.

I'm not a native English speaker, but I read the new sentence as "the
$KDIR variable holds the path to the kernel source directory, you can
use the following commands verbatim", instead of "$KDIR is used in place
of the path to the kernel source directory, replace it with the actual
path".


>  
> -	make -C $KDIR M=`pwd`
> -		Will build the module(s) located in current directory.
> -		All output files will be located in the same directory
> -		as the module source.
> -		No attempts are made to update the kernel source, and it is
> -		a precondition that a successful make has been executed
> -		for the kernel.
> +	make -C $KDIR
> +		-C is used to specify where to find the kernel source.
> +		'make' will actually change to the specified directory
> +		when executing and will change back when finished.
>  
> -	make -C $KDIR M=`pwd` modules
> -		The modules target is implied when no target is given.
> -		Same functionality as if no target was specified.
> -		See description above.
> +	make -C $KDIR M=$PWD
> +		M= is used to tell kbuild that an external module is being
> +		built. The option given to M= is the directory where the
> +		external module (kbuild file) is located.
>  
> -	make -C $KDIR M=`pwd` modules_install
> -		Install the external module(s).
> -		Installation default is in /lib/modules/<kernel-version>/extra,
> -		but may be prefixed with INSTALL_MOD_PATH - see separate
> -		chapter.
> +	make -C $KDIR SUBDIRS=$PWD
> +		Same as M=. The SUBDIRS= syntax is kept for backwards
> +		compatibility, but its usage is deprecated.

While you are rewriting the file, you can also drop the reference to
SUBDIRS. It has been deprecated for over six years, so it doesn't need
to be documented anymore, IMO. BTW, I like how you swapped the two
sections, it is more logical that way.

[...]
> -	Examples (module foo.ko, consist of bar.o, baz.o):
> -		make -C $KDIR M=`pwd` bar.lst
[...]
> +		make -C $KDIR M=$PWD bar.o

make -C $KDIR M=`pwd` bar.lst was a valid command, see make help:

  dir/file.lst    - Build specified mixed source/assembly target only
                    (requires a recent binutils and recent build
(System.map))

Perhaps there should be a short sentence explaining what the four
commands do.

The rest looks OK to me (although I can't really comment on the language
part), thanks a lot for looking into this.

Michal
