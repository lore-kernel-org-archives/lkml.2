Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0DMUnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab0DMUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:43:46 -0400
Date: Tue, 13 Apr 2010 16:44:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       linux-kernel@vger.kernel.org, davej@redhat.com, kyle@redhat.com,
       vgoyal@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] kconfig: introduce nonint_oldconfig and
	loose_nonint_oldconfig
Message-ID: <20100413204427.GZ31193@redhat.com>
References: <20100413194747.GX31193@redhat.com> <20100413130031.d4dec19b.randy.dunlap@oracle.com> <20100413201759.GY31193@redhat.com> <4BC4D310.6060705@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC4D310.6060705@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> This patch has been around for a long time in Fedora and Red Hat Enterprise
> >>> Linux kernels and it may be useful for others. The nonint_oldconfig target
> >>> will fail and print the unset config options while loose_nonint_oldconfig will
> >>> simply let the config option unset. They're useful in distro kernel packages
> >>> where the config files are built using a combination of smaller config files.
> >>> The patch's author AFAIK is Arjan van de Ven. Arjan, please add a Signed-off-by
> >>> if you're the original author.
> >>
> >> Roland McGrath added the loose parts according to his email of 2008.Mar.05:
> >> "I added this one (loose_nonint_oldconfig target, -B option to conf)."
> > hm, I can't see the -B there, maybe the functionality he's referring to is
> > the def_no?
> 
> +loose_nonint_oldconfig: $(obj)/conf
> +	$< -B $(Kconfig)
> 
> ...
> 
> +		case 'B':
> +			input_mode = dont_ask_dont_tell;
> +			break;
ah, duh, you mean he's the author of loose_nonint_oldconfig. I somewhat thought
you said the loose_nonint_oldconfig functionality was already in :)

> >> after Dave Jones posted this patch.
> >>
> >> (adding linux-kbuild mailing list & kbuild maintainer)
> >>
> >> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >>
> >>
> >>> Signed-off-by: Aristeu Rozanski <aris@redhat.com> 
> >>
> >>
> >>> @@ -613,5 +641,5 @@ int main(int ac, char **av)
> >>>  			exit(1);
> >>>  		}
> >>>  	}
> >>> -	return 0;
> >>> +	return return_value;
> >>>  }
> >>
> >> Having 'make oldconfig' exit with Exit status: 139  (for example)
> >> can be confusing.  I know that from experience.  It took me a bit
> >> to find out what that meant.  That part could be improved...
> > ok, no real reason to keep incrementing that. no different error codes exist
> > other than "1". Do you think we need to introduce different return codes?
> > 
> 
> I would prefer a fixed value, like 86.  or 11.  or a useful printf text message.
ok, will refresh and resend

-- 
Aristeu

