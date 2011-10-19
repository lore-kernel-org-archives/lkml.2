Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1JSOFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:05:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45274 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1JSOFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:05:15 -0400
Date: Wed, 19 Oct 2011 10:04:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] XEN_DOMAIN_MEMORY options.
Message-ID: <20111019140406.GB7313@phenom.dumpdata.com>
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
 <4E98BEF5.10801@goop.org>
 <4E98C6CE.4020508@oracle.com>
 <4E98C8B1.20304@goop.org>
 <4E98D739.4000705@oracle.com>
 <20111015130552.GC18864@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015130552.GC18864@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020A.4E9ED8E6.000F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>>What's the rationale?
> > >>>
> > >>>      J
> > >>
> > >>The first patch is actually bug fix. You can not define just "int"
> > >>without description in Kconfig. As the result this option will not be
> > >>visible in menuconfig. Even if you will change it in .config make
> > >>oldconfig will set it up for default value. So you need to add any
> > >>description to it as all others int options have.
> > >
> > >No, that was deliberate, because I don't really think there's a need to
> > >change it.
> > >
> > 
> > From that point of view it's not clear why this option is still in Kconfig?
> 
> Well, we do need to alter it to 512GB. Actually -  putting that extra
> burden on initial pagetables to reserve extra 384 pages might be a bit
> too much. Even thought later on we reclaim it if we do not use it.

Jeremy, without that change, you cannot specify

CONFIG_XEN_MAX_DOMAIN_MEMORY=512

if the distro desires to do so. Well, you can write it in the .config,
but the moment you compile, the oldconfig rewrites it to 128.

