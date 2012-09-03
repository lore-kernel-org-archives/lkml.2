Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2ICVQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 17:16:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64347 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2ICVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 17:16:03 -0400
Message-ID: <50451E0E.1050605@suse.cz>
Date: Mon, 03 Sep 2012 23:15:58 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Millenbach <jmillenbach@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, team-fjord@googlegroups.com,
        Josh Triplett <josh@joshtriplett.org>,
        "jirisl >> Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCHv2] tty: Added a CONFIG_TTY option to allow removal of
 TTY
References: <1346633072-29361-1-git-send-email-jmillenbach@gmail.com>
In-Reply-To: <1346633072-29361-1-git-send-email-jmillenbach@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 02:44 AM, Joe Millenbach wrote:
> The option allows you to remove TTY and compile without errors. This
> saves space on systems that won't support TTY interfaces anyway.
> bloat-o-meter output is below.
...
> --- a/drivers/tty/Kconfig
> +++ b/drivers/tty/Kconfig
> @@ -1,3 +1,14 @@
> +config TTY
> +	bool "Enable TTY" if EXPERT
> +	default y
> +	---help---
> +	  Allows you to remove TTY support which can save space, and
> +	  blocks features that require TTY from inclusion in the kernel.
> +	  TTY is required for any text terminals or serial port
> +	  communication. Most users should leave this enabled.
> +
> +if TTY
> +
>  config VT
>  	bool "Virtual terminal" if EXPERT
>  	depends on !S390 && !UML
> @@ -355,6 +366,8 @@ config TRACE_SINK
>  	  If you select this option, you need to select
>  	  "Trace data router for MIPI P1149.7 cJTAG standard".
>  
> +endif # TTY
> +
>  config PPC_EPAPR_HV_BYTECHAN
>  	tristate "ePAPR hypervisor byte channel driver"
>  	depends on PPC

Hmm, I wonder why do not you include EHV in the depends-on-tty list?

thanks,
-- 
js
suse labs
