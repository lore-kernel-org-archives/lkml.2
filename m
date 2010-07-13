Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0GMM5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 08:57:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0GMM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 08:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X9KKqikog5qzSw1VFNkCl5zRhLvV7l2AG816tuJjFh25phq84WsCmFz3LOLfTWMeuA
         5epjFZoiX3EjmDIsGVmgDO/0PNOXPNZ3Dn06QafOXTJ5Xv28tN8hidUVrVuRcAt5mvg5
         50lJOycrGb67Jfb1yRPYDlyPuoWhCGlal5OiM=
Date: Tue, 13 Jul 2010 14:57:09 +0200
From: Martin Jansa <martin.jansa@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: setlocalversion should respect srctree param
 when looking for auto.conf
Message-ID: <20100713125709.GK15231@jama>
References: <1279013676-23887-1-git-send-email-Martin.Jansa@gmail.com>
 <4C3C5DE3.7030306@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3C5DE3.7030306@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 02:36:51PM +0200, Michal Marek wrote:
> On 07/13/2010 11:34 AM, Martin Jansa wrote:
> > * it works properly only when CWD == scrtree
> > * with this patch:
> >   jama src # /usr/src/linux/scripts/setlocalversion /usr/src/linux
> >   -JaMa-00001-g18672de
> > * without:
> >   jama src # /usr/src/linux/scripts/setlocalversion /usr/src/linux
> >   Error: kernelrelease not valid - run 'make prepare' to update it
> 
> This doesn't look correct, include/config/auto.conf is generated in the
> build directory (*), where this script is called from by the Makefile.
> If you call the script manually, you have to cd to the build directory
> first.
> 
> (*) which is different from the source directory if you build with O=.

Ah OK, I didn't notice that auto.conf should be generated in build
directory (in my case build dir == source dir).

I just noticed broken kernel module builds in gentoo, because local
version is also checked without changing CWD
KV_LOCAL="${KV_LOCAL}$(sh ${KV_DIR}/scripts/setlocalversion ${KV_DIR})"
in get_version()
http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/linux-info.eclass?view=markup

So if scripts/* behavior is not considered as "API" then it should be
fixed in gentoo eclass. It also appends LOCALVERSION twice now, because
first appends LOCALVERSION from config and then calls setlocalversion
also returning it at the beginning.

Thanks

Regards,

-- 
Martin 'JaMa' Jansa     jabber: Martin.Jansa@gmail.com
