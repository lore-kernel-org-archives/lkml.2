Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab2IGJjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:39:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45237 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2IGJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:39:00 -0400
Date: Fri, 7 Sep 2012 11:38:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Bernhard Walle <bernhard@bwalle.de>,
        Michal Marek <mmarek@suse.cz>, kernel@pengutronix.de
Subject: Re: [PATCH] Make: Fix if_changed when command contains backslashes
Message-ID: <20120907093855.GR26594@pengutronix.de>
References: <1347010552-26595-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347010552-26595-1-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:37:21 up 76 days, 49 min, 60 users,  load average: 0.13, 0.13,
 0.30
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:35:52AM +0200, Sascha Hauer wrote:
> The call if_changed mechanism does not work when the command
> contains backslashes. This basically is an issue with lzo
> and bzip2 compressed kernels. The compressed binaries do not
> contain the uncompressed image size, so these use size_append
> to append the size. This results in backslashes in the executed
> command. With this if_changed always detects a change in the
> command and rebuilds the compressed image even if nothing
> has changed.
> 
> Fix this by escaping backslashes in make-cmd
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

This was found and fixed together with Jan Lübbe, so I should not
forget his credits:

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>

Sascha

> ---
>  scripts/Kbuild.include |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index 6a3ee98..afa4459 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -209,7 +209,7 @@ endif
>  # >$< substitution to preserve $ when reloading .cmd file
>  # note: when using inline perl scripts [perl -e '...$$t=1;...']
>  # in $(cmd_xxx) double $$ your perl vars
> -make-cmd = $(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1)))))
> +make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
>  
>  # Find any prerequisites that is newer than target or that does not exist.
>  # PHONY targets skipped in both cases.
> -- 
> 1.7.10.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
