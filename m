Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1LKUeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:34:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab1LKUeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:34:02 -0500
Message-ID: <4EE513BA.5020708@suse.cz>
Date: Sun, 11 Dec 2011 21:34:02 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] try to create KBUILD_OUTPUT automatically
References: <alpine.LNX.2.00.1110221049460.59156@linux>
In-Reply-To: <alpine.LNX.2.00.1110221049460.59156@linux>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.10.2011 17:12, Peter Foley wrote:
> This patch makes it possible to execute make O=work instead of
> mkdir work
> make O=work
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 2652089..a4769ac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -117,7 +117,7 @@ ifneq ($(KBUILD_OUTPUT),)
>  # Invoke a second make in the output directory, passing relevant variables
>  # check that the output directory actually exists
>  saved-output := $(KBUILD_OUTPUT)
> -KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
> +KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && /bin/pwd)
>  $(if $(KBUILD_OUTPUT),, \
>       $(error output directory "$(saved-output)" does not exist))

I think it's a good idea, but please also change the comment and error
message. The command will now only fail if the directory cannot be
created, not if it does not exist.

Michal
