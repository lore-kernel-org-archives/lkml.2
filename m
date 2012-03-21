Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2CUP2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:28:09 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:8539 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab2CUP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:28:07 -0400
Date: Wed, 21 Mar 2012 16:27:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] thermal: Fix for setting the thermal zone mode to
 enable/disable
Message-ID: <20120321162757.527f87e2@endymion.delvare>
In-Reply-To: <CAMuHMdUFh=kRJFGP3sxHCqERSVcrWGD40iYzhrFMRxDNFvounA@mail.gmail.com>
References: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
	<20120321151357.53fb86e4@endymion.delvare>
	<CAMuHMdUFh=kRJFGP3sxHCqERSVcrWGD40iYzhrFMRxDNFvounA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 16:14:46 +0100, Geert Uytterhoeven wrote:
> On Wed, Mar 21, 2012 at 15:13, Jean Delvare <khali@linux-fr.org> wrote:
> > On Wed, 21 Mar 2012 16:40:01 +0530, Amit Daniel Kachhap wrote:
> >> Basically without this patch changing the mode of thermal zone
> >> is not possible as wrong string size is passed to strncmp.
> >
> > Actually it is possible,
> > $ echo -n disabled > mode
> > works fine. But it fails without the -n, your patch would fix that.
> 
> Now it ignores any extra characters. Are they always newlines?
> 
> Now "echo -n disabledx > mode" will also "succeed".

I guess this is considered good enough in practice, although I also
don't like this use of strncmp. I'd prefer \n to be properly converted
to \0 (by the sysfs layer itself) so that strict string comparisons can
be done. I don't have the time to push this though, sorry.

-- 
Jean Delvare
