Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab0KDNeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:34:02 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:49530 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab0KDNeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:34:00 -0400
Message-ID: <4CD2B646.3090100@asbjorn.biz>
Date: Thu, 04 Nov 2010 13:33:58 +0000
From: =?ISO-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross	compiling
References: <4CD22ACF.1000407@asbjorn.it> <1288842244-6863-1-git-send-email-asbjorn@asbjorn.biz> <20101104055800.GA11781@merkur.ravnborg.org> <4CD2A725.7030809@asbjorn.biz> <4CD2A8BC.3010500@suse.cz>
In-Reply-To: <4CD2A8BC.3010500@suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 12:36 PM, Michal Marek wrote:
> On 4.11.2010 13:29, Asbjørn Sloth Tønnesen wrote:
>> No, not if you are cross compiling since ARCH=x86 isn't specific to
>> either, we would have to look at the config. In that case it is better
>> to do something like:
>>
>> x86|i386|x86_64)
>> 	debarch=$(grep -q CONFIG_64BIT=y .config &&
> 
> No, you should use $UTS_MACHINE (`uname -m` in the resulting kernel),
> like make rpm-pkg does, and only translate x86_64 to amd64.

Ok, sorry, hadn't caught that it was on the resulting kernel.

So that solves the x86 architectures, but according to a quick git grep,
.config analysis is still needed for arm(el) and mips(el).
