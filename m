Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab0KDMgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 08:36:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0KDMgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:36:14 -0400
Message-ID: <4CD2A8BC.3010500@suse.cz>
Date: Thu, 04 Nov 2010 13:36:12 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <asbjorn@asbjorn.biz>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross	compiling
References: <4CD22ACF.1000407@asbjorn.it> <1288842244-6863-1-git-send-email-asbjorn@asbjorn.biz> <20101104055800.GA11781@merkur.ravnborg.org> <4CD2A725.7030809@asbjorn.biz>
In-Reply-To: <4CD2A725.7030809@asbjorn.biz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.11.2010 13:29, Asbjørn Sloth Tønnesen wrote:
> No, not if you are cross compiling since ARCH=x86 isn't specific to
> either, we would have to look at the config. In that case it is better
> to do something like:
> 
> x86|i386|x86_64)
> 	debarch=$(grep -q CONFIG_64BIT=y .config &&

No, you should use $UTS_MACHINE (`uname -m` in the resulting kernel),
like make rpm-pkg does, and only translate x86_64 to amd64.

Michal
