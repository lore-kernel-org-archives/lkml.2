Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1BDToZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:44:25 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55011 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1BDToY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LSlzNATxmzmR3i1LO0SoWDTzfgHpccRMxXyqd22IdqICjPajhvkvCbpvNyBcNSLkRf
         TG6XxZ0MraHOY3x+curzOdaLjmUTpwLdJknE0Cetx8srEszzE3Lybi/2yNzKVVxr3fdd
         ismYPE+iHMVj+QkQb6c+VifyGcGA0Eb+AjPXs=
MIME-Version: 1.0
In-Reply-To: <1296783486-23033-1-git-send-email-kamal@canonical.com>
References: <1296783486-23033-1-git-send-email-kamal@canonical.com>
Date: Fri, 4 Feb 2011 11:44:23 -0800
X-Google-Sender-Auth: z-iIu1H3YKraE2z_3MH37C15nFA
Message-ID: <AANLkTimDrWESfmSwRSyhenZTwXovKKa4mSC=Y0=j9yPM@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: fix panic when handling "mem={invalid}" param
From: Yinghai Lu <yinghai@kernel.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 5:38 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> Avoid removing all of memory and panicing when "mem={invalid}" is
> specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on platforms
> other than x86_32).
>
> BugLink: http://bugs.launchpad.net/bugs/553464
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> Cc: <stable@kernel.org>
> ---
>  arch/x86/kernel/e820.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 294f26d..55a59d8 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -856,6 +856,9 @@ static int __init parse_memopt(char *p)
>
>        userdef = 1;
>        mem_size = memparse(p, &p);
> +       /* don't remove all of memory when handling "mem={invalid}" param */
> +       if (mem_size == 0)
> +               return -EINVAL;
>        e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
>
>        return 0;
> --

then how about some one pass mem=32M etc?

or total wrongly usermap?

Yinghai
