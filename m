Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0G2Ozb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:55:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:49486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab0G2Oz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:55:29 -0400
Date: Thu, 29 Jul 2010 16:54:41 +0200
From: Michal Marek <mmarek@suse.cz>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Ulf Magnusson <ulfalizer.lkml@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.35-rc6] kconfig: fix MODULES-related bug in case of
 no .config
Message-ID: <20100729145438.GA18251@sepie.suse.cz>
References: <20100727192727.GA17954@ulf>
 <20100727195742.GA18079@ulf>
 <20100728062313.GC5161@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100728062313.GC5161@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 02:23:13PM +0800, Américo Wang wrote:
> On Tue, Jul 27, 2010 at 09:57:43PM +0200, Ulf Magnusson wrote:
> >On Tue, Jul 27, 2010 at 09:27:27PM +0200, Ulf Magnusson wrote:
> >> Hi,
> >> 
> >> There seems to be a kconfig bug due to MODULES not always being evaluated if no
> >> .config is found. Take the following Kconfig as an example:
> >> 
> >> config MODULES
> >> 	def_bool y
> >> 
> >> config FOO
> >> 	def_tristate m
> >> 
> >> With no .config, the following configuration is generated:
> >> 
> >> CONFIG_MODULES=y
> >> CONFIG_FOO=y
> >> 
> >> With an empty .config, the following:
> >> 
> >> CONFIG_MODULES=y
> >> CONFIG_FOO=m
> >> 
> >> Tristate choice statements can also exhibit the problem, due to having an
> >> implicit rev_dep (select) containing "m".
> >> 
> >> The problem is that MODULES is never evaluted in conf_read_simple() unless
> >> there's a .config. The following patch fixes this.
> 
> <snip>
> 
> >
> >Silly error in the patch. The correct patch follows.

Even the previous patch was correct, sym_calc_value() does nothing if
the argument is NULL.

> >
> >Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
> >
> 
> Sounds good for me.
> 
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks. Added for  2.6.36 to kbuild-2.6.git (this is not a .35
regression AFAICS).

Michal
