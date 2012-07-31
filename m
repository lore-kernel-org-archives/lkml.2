Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2GaO4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:56:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41063 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab2GaO4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:56:17 -0400
Date: Tue, 31 Jul 2012 15:56:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/5] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120731145614.GZ4468@opensource.wolfsonmicro.com>
References: <1343745944-18418-1-git-send-email-lee.jones@linaro.org>
 <1343745944-18418-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343745944-18418-2-git-send-email-lee.jones@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:45:40PM +0100, Lee Jones wrote:
> If a list of widgets is provided and one of them fails to be added as
> a control, the present semantics fail all subsequent widgets. A better
> solution would be to only fail that widget, but pursue in attempting
> to add the rest of the list.

To reiterate, this is in *no* way urgent or even a bug fix.

>  			dev_err(dapm->dev,
>  				"ASoC: Failed to create DAPM control %s\n",
>  				widget->name);
> -			ret = -ENOMEM;
> -			break;

Indeed, removing the error return is a regression.
