Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2DSNJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:09:00 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43265 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2DSNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:08:59 -0400
From: Serge Hallyn <serge@hallyn.com>
Reply-To: Serge Hallyn <serge@hallyn.com>
To: Tony Luck <tony.luck@intel.com>, Eric Paris <eparis@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: ia64 build broken by patch to security/commoncap.c
X-Mailer: Modest 3.2
References: <CA+8MBbKYXV6e0u5bOgr1GUs0ng0F-vGv5rVxnM26B8Dv+2RyLw@mail.gmail.com>
In-Reply-To: <CA+8MBbKYXV6e0u5bOgr1GUs0ng0F-vGv5rVxnM26B8Dv+2RyLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-ID: <1334796505.1457.4.camel@Nokia-N900-51-1>
Date: Wed, 18 Apr 2012 19:48:25 -0500
Message-Id: <1334796505.1457.5.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, it's been repolrted (and the fix acked) but i guess that wasn't cc:d to lkml?

----- Original message -----
> commit d52fc5dde171f030170a6cb78034d166b13c9445
> fcaps: clear the same personality flags as suid when fcaps are used
> 
> just appeared in Linus's tree and broke the ia64 build with:
> 
> security/commoncap.c: In function ‘cap_bprm_set_creds’:
> security/commoncap.c:510: error: ‘PER_CLEAR_ON_SETID’ undeclared
> (first use in this function)
> 
> Cause seems to be a missing:
> 
> #include <linux/personality.h>
> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at   http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at   http://www.tux.org/lkml/

