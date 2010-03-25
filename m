Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0CYNbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:31:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab0CYNbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:31:12 -0400
X-Authority-Analysis: v=1.0 c=1 a=InLQgaHwsNUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=5z4-308xI5hSaFz7y-MA:9 a=elkLKcYYzdBhTRxR6EkA:7 a=rNN4jiPvZBraRiHz-nK0En_HU_oA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace-cmd: Add BUILDING and INSTALL instructions to
 README
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1269509057-4336-1-git-send-email-jkacur@redhat.com>
References: <1269509057-4336-1-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Mar 2010 09:31:08 -0400
Message-ID: <1269523868.2957.4060.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 10:24 +0100, John Kacur wrote:
> - Add BUILDING and INSTALL instructions to the README
> - Change Makefile so that messages don't appear like errors.

Thanks,

Did you rebase your repo or do I need to pull in the other patches from
the mbox?

One comment below.

> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  Makefile |    6 +++---
>  README   |   26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 8a3f25c..04fe380 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -373,10 +373,10 @@ ifneq ($(dep_includes),)
>  endif
>  
>  show_gui_make:
> -	@echo "*** to build the gui, type \"make gui\" ***"
> +	@echo "Note: to build the gui, type \"make gui\""
>  
>  show_gui_done:
> -	@echo "*** gui build complete ***"
> +	@echo "gui build complete"
>  
>  PHONY += show_gui_make
>  
> @@ -397,7 +397,7 @@ install_cmd: all_cmd install_plugins
>  	$(INSTALL) trace-cmd '$(bindir_SQ)'
>  
>  install: install_cmd
> -	@echo "*** to install the gui, type \"make install_gui\" ***"
> +	@echo "Note: to install the gui, type \"make install_gui\""
>  
>  install_gui: install_cmd gui
>  	$(INSTALL) -d -m 755 '$(bindir_SQ)'
> diff --git a/README b/README
> index 7ac4390..d191197 100644
> --- a/README
> +++ b/README
> @@ -9,3 +9,29 @@ These files also make up the code to create the libraries
>  The applications are licensed under the GNU General Public License 2.0
>  (see COPYING) and the libraries are licensed under the GNU
>  Lesser General Public License 2.1 (See COPYING.LIB).
> +
> +BUILDING:
> +
> +To make trace-cmd
> +    make
> +
> +To make the gui
> +    make gui
> +
> +INSTALL:
> +
> +To install trace-cmd
> +    make install
> +
> +To install the gui
> +    make install_gui
> +
> +Note: The default install is relative to /usr/local
> +    The default install directory is /usr/local/bin
> +    The default plugin directory is /usr/local/share/trace-cmd/plugins
> +
> +To change the default, you can set 'prefix', eg
> +mkdir $HOME/test-trace
> +make prefix=$HOME/test-trace
> +make prefix=$HOME/test-trace install

Looks good, but I would use the example of this:

make prefix=~
make prefix=~ install

The above would install the executables into your home directory ~/bin
and the plugins into ~/.trace-cmd/plugins

-- Steve

> +


