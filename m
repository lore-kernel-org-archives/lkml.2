Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab0HFGBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:01:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53889 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0HFGBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AmRmQiQ/H/f7qgFWK5WzhuMA3cQ8i91bK7S1a1XTFPSBvKXA6BKDjMqir4SAUtrGWV
         e7gxPhRDNkNEcDSECTxmhNp5hJF1A3zeOZ10edMVzl44jr2uIlCofIY0Ryueb5fXC9Og
         oWdE6VqlYVuHHNvGjqDTWsMVNwwLbEJ4XnCCo=
Message-ID: <4C5BA55B.7050202@gmail.com>
Date: Thu, 05 Aug 2010 23:02:03 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, JBeulich@novell.com, aris@redhat.com,
        catalin.marinas@arm.com, jacmet@sunsite.dk, lizf@cn.fujitsu.com,
        ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix make oldconfig
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> <4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com> <20100806051354.GA24343@merkur.ravnborg.org>
In-Reply-To: <20100806051354.GA24343@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] kconfig: fix make oldconfig
>
> Linus wrote:
>   This seems to make "make oldconfig" a _lot_ more verbose than it
>   used to be. In a very annoying way.
>
>   I just did a quick git bisect. It's introduced by commit 4062f1a4c030
>   ("kconfig: use long options in conf") by Sam Ravnborg. Apparently that
>   thing is totally buggy, and doesn't just change the option names, but
>   actively breaks them.
>
> The old behaviour (from years ago) were reintroduced by accident.
> Fix this so we are back to the version that are silent
> if there is nothing to ask about.
>
> Reported-by: Linus Torvalds<torvalds@linux-foundation.org>
> Signed-off-by: Sam Ravnborg<sam@ravnborg.org>
> ---
>
> Sorry for this regression. Dunno how I missed it.
> I guess I only tested "silentoldconfig".
>
> Following patch seems obviously correct but as I am on the way
> out of the door I could not do much testing.
>
> 	Sam
>
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 010600e..274f271 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -599,12 +599,12 @@ int main(int ac, char **av)
>   		break;
>   	case savedefconfig:
>   		break;
> -	case oldconfig:
>   	case oldaskconfig:
>   		rootEntry =&rootmenu;
>   		conf(&rootmenu);
>   		input_mode = silentoldconfig;
>   		/* fall through */
> +	case oldconfig:
>   	case listnewconfig:
>   	case oldnoconfig:
>   	case silentoldconfig:
>

Id like to be more useful with really hitting this, seems I was for a 
few moments, then something in there tripped and caused oldconfig to 
behave.. anyways only real evidence I have of hitting this is an fpaste 
of my shell output http://fpaste.org/LFew/

Anyways applied your patch below, make oldconfig worked as is no:

  make oldconfig
scripts/kconfig/conf -o arch/x86/Kconfig
#
# configuration written to .config
#

that I was hitting for some reason or another then all of a sudden 
disappeared.

Justin P. Mattock
