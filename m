Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab2HHUEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:04:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47770 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2HHUEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:04:09 -0400
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: John Stultz <johnstul@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
In-Reply-To: <1469977.Edv3iizobX@sifl>
References: <50215A7E.8000701@linaro.org> <17464273.DGOeQvDGIE@sifl>
	 <1344454701.28967.233.camel@edumazet-glaptop>  <1469977.Edv3iizobX@sifl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 22:04:02 +0200
Message-ID: <1344456242.28967.238.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 15:50 -0400, Paul Moore wrote:

> Yep.  I was just trying to see if there was a way we could avoid having to 
> make it conditional on CONFIG_SECURITY, but I think this is a better approach 
> than the alternatives.
> 
> I'm also looking into making sure we get a sane LSM label on the per-cpu sock 
> as security_sk_alloc() just allocates and initializes the LSM blob to a basic 
> starting value (unlabeled_t in the case of SELinux) ... that is likely to be 
> the tricky bit.

It seems previous code did the same thing in sk_prot_alloc() ?


> 
> Regardless, I'm okay with us merging the patch below now to fix the panic and 
> I'll supply a follow-up patch to fix the labeling once I figure out a solution 
> that seems reasonable.  Does that work for you?  David?
> 
> Acked-by: Paul Moore <paul@paul-moore.com>

John, could you confirm this fixes the problem ?


