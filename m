Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0IXVBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:01:21 -0400
Received: from borg.medozas.de ([188.40.89.202]:34022 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0IXVBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:01:19 -0400
Date: Fri, 24 Sep 2010 23:01:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
        paul.moore@hp.com, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
Subject: Re: [PATCH 1/6] secmark: do not return early if there was no error
In-Reply-To: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LNX.2.01.1009242300400.3599@obet.zrqbmnf.qr>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2010-09-24 22:45, Eric Paris wrote:

>Commit 4a5a5c73 attempted to pass decent error messages back to userspace for
>netfilter errors.  In xt_SECMARK.c however the patch screwed up and returned
>on 0 (aka no error) early and didn't finish setting up secmark.  This results
>in a kernel BUG if you use SECMARK.

>+++ b/net/netfilter/xt_SECMARK.c
>@@ -101,7 +101,7 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
> 	switch (info->mode) {
> 	case SECMARK_MODE_SEL:
> 		err = checkentry_selinux(info);
>-		if (err <= 0)
>+		if (err)
> 			return err;

Indeed the = is unwanted and err < 0 was intended here.
Sorry for the slip.
