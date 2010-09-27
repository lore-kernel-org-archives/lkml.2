Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab0I0S3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:29:25 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44036 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0I0S3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:29:23 -0400
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
From: Paul Moore <paul.moore@hp.com>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
        sds@tycho.nsa.gov, jengelh@medozas.de, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
In-Reply-To: <1285606896.2815.36.camel@localhost.localdomain>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>
	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
	 <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>
	 <1285606896.2815.36.camel@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Organization: Hewlett Packard
Date: Mon, 27 Sep 2010 14:29:16 -0400
Message-ID: <1285612156.4935.16.camel@sifl>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 13:01 -0400, Eric Paris wrote:
> On Mon, 2010-09-27 at 10:50 +1000, James Morris wrote:
> > On Fri, 24 Sep 2010, Eric Paris wrote:
> 
> > For the reasons above, I think the secctx string needs to be exported in 
> > addition to this rather than instead of.
> 
> I won't argue, I don't agree with your reasoning, but I'm not opposed to
> this result.  We have 3 competing suggestions:
> 
> Jan suggested we:
> completely eliminate secmark from procfs+netlink and only export secctx
> in netlink.
> 
> Eric suggested we:
> completely eliminate secmark from procfs+netlink and then export secctx
> in procfs+netlink
> 
> sounds like James suggested we:
> continue to export meaningless and confusing secmark from procfs+netlink
> and then export secctx in procfs+netlink as well.
> 
> I'm going to implement James' idea and resend the patch series.  Any
> strong objections?

I apologize for not getting a chance to look at these patches sooner.
In general they look fine to me and my only real concern was addressed
by Pablo already (breaking userspace due to #define changes).

As far as exporting the 32bit secid/secmark to userspace, I think that
is a mistake.  James correctly points out that it does map to a LSM
specific value, e.g. SELinux and Smack security labels, but I don't
think he makes it clear that in the two LSMs that currently use secids
the mapping between the secid and the secctx is not constant; the secids
are transient values that will change with each boot in a manner that
userspace can not predict.  For this reason, I think exporting the
secids is only going to cause users/admins grief, whereas exporting the
associated secctx should be a much more stable value and is likely what
the user/admin is expecting anyway.

-- 
paul moore
linux @ hp


