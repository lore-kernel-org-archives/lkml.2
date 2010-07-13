Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0GMQJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:09:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0GMQJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:09:03 -0400
Message-ID: <4C3C8F9A.2070608@suse.cz>
Date: Tue, 13 Jul 2010 18:08:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Martin Jansa <martin.jansa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: setlocalversion should respect srctree param
 when looking for auto.conf
References: <1279013676-23887-1-git-send-email-Martin.Jansa@gmail.com> <4C3C5DE3.7030306@suse.cz> <20100713125709.GK15231@jama>
In-Reply-To: <20100713125709.GK15231@jama>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 02:57 PM, Martin Jansa wrote:
> I just noticed broken kernel module builds in gentoo, because local
> version is also checked without changing CWD
> KV_LOCAL="${KV_LOCAL}$(sh ${KV_DIR}/scripts/setlocalversion ${KV_DIR})"
> in get_version()
> http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/linux-info.eclass?view=markup
> 
> So if scripts/* behavior is not considered as "API" then it should be
> fixed in gentoo eclass. It also appends LOCALVERSION twice now, because
> first appends LOCALVERSION from config and then calls setlocalversion
> also returning it at the beginning.

I didn't expect that anyone would really use the setlocalversion script
manually, it's hard to draw the line between internal kbuild helpers and
scripts for users. But I'm wondering, why don't you simply do 'make -s
-C $KV_DIR kernelrelease' instead of reimplementing the whole logic
again? You also seem to miss CONFIG_LOCALVERSION.

Michal
