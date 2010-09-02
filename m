Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0IBQwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:52:47 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:54043 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0IBQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:52:45 -0400
From: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] xconfig: Change the titlebar if using Qt3
Date: Thu, 2 Sep 2010 18:52:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-gentoo-r6; KDE/4.5.1; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1283355997-6900-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1283355997-6900-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009021852.40023.alexander.stein@informatik.tu-chemnitz.de>
X-Spam-Score: -0.9 (/)
X-Spam-Report: --- Start der SpamAssassin 3.3.1 Textanalyse (-0.9 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.1 TVD_RCVD_IP TVD_RCVD_IP
 --- Ende der SpamAssassin Textanalyse
X-Scan-Signature: aa86db5e7f3e85aa9355d5c307b12c26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marek,

On Wednesday 01 September 2010 17:46:37 Michal Marek wrote:
> Qt4 is now used by default and will get more testing. In case someone
> still uses Qt3 and reports a bug, make it easy to recognize that this is
> Qt3.
> 
> Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/kconfig/qconf.cc |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index 88d3874..a04e451 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -1274,8 +1274,14 @@ ConfigMainWindow::ConfigMainWindow(void)
>  	char title[256];
> 
>  	QDesktopWidget *d = configApp->desktop();
> -	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration"),
> -		getenv("KERNELVERSION"));
> +	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration%s"),
> +		getenv("KERNELVERSION"),
> +#if QT_VERSION < 0x040000
> +		" (Qt3)"
> +#else
> +		""
> +#endif
> +		);
>  	setCaption(title);
> 
>  	width = configSettings->readNumEntry("/window width", d->width() - 64);

Looks fine to me.

Best regards,
Alexander
