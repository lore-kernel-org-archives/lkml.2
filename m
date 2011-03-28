Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1C1Or2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:47:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46824 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1C1Or1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=smXXAJ3hlN8oyNBccUyFH0Y18D3ftRnXWydyJlrJuOqHuO/yKwQvR9EVAin1Wljgs2
         kV2OSxTYGAZLS0dpkXi7fujkw0LyIisRV4yETDZMpsNoV2nAMQ5zrPYPDOjO8GpSqa3v
         FgpW3+q3k664jFL2wlVHuNLKgnmgScgtJdYaY=
Date: Mon, 28 Mar 2011 11:47:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110328144721.GB17872@ghostprotocols.net>
References: <20110326224408.GA1336@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110326224408.GA1336@Xye>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 27, 2011 at 04:14:08AM +0530, Raghavendra D Prabhu escreveu:
> On systems with python{2,3} installed, perf build can break which can be fixed by
> exporting PYTHON to the right value. Added support for PYTHON in the Makefile.
> ---
>  tools/perf/Makefile |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)

Can you please add your Signed-off-by line? Please check
Documentation/SubmittingPatches, "12) Sign your work".

Also please check the encoding, I'm getting things like:

@@ -629,10 +632,11 @@ endif
  ifdef NO_LIBPYTHON
        BASIC_CFLAGS +=3D -DNO_LIBPYTHON
  else
-       PYTHON_EMBED_LDOPTS =3D $(shell python-config --ldflags 2>/dev/null)
+       PYTHON ?=3D /usr/bin/python
+       PYTHON_EMBED_LDOPTS =3D $(shell $(PYTHON)-config --ldflags 2>/dev/n=
ull)

See the /dev/null line wrapping? Also the +=3D, perhaps sending as an
attachment helps.

For more info please read Documentation/email-clients.txt .

The patch looks otherwise a fix, so please take care of the avove issues and
resubmit,

Michael, if you could double check and give me your Acked-by, that would be
appreciated :-)

Thanks,

- Arnaldo

 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 7141c42..d998221 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -149,6 +149,9 @@ endif
>  #
>  # Define NO_PERL if you do not want Perl scripts or libraries at all.
>  #
> +# Define PYTHON to point to python binary if it is not
> +# /usr/bin/python, it will be used/called as $PYTHON-config.
> +#
>  # Define INTERNAL_QSORT to use Git's implementation of qsort(), which
>  # is a simplified version of the merge sort used in glibc. This is
>  # recommended if Git triggers O(n^2) behavior in your platform's qsort().
> @@ -629,10 +632,11 @@ endif
>  ifdef NO_LIBPYTHON
>  	BASIC_CFLAGS += -DNO_LIBPYTHON
>  else
> -       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
> +       PYTHON ?= /usr/bin/python
> +       PYTHON_EMBED_LDOPTS = $(shell $(PYTHON)-config --ldflags 2>/dev/null)
>         PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
>         PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
> -	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
> +	PYTHON_EMBED_CCOPTS = ` $(PYTHON)-config --cflags 2>/dev/null`
>  	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
>  	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
>  		BASIC_CFLAGS += -DNO_LIBPYTHON
> -- 
> 1.7.4.1
> 
> --------------------------
> Raghavendra Prabhu
> GPG ID:D72BE977
> 


