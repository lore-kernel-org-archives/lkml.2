Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030859Ab2HHVJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:09:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39117 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2HHVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <1463614.KLCBsoWyCC@sifl>
References: <50215A7E.8000701@linaro.org>
	<2294220.dmCbVvF3Tg@sifl>
	<CACLa4pu4SFHp9nxp4RJ1L4a-cz+qPaYrGCULLGXDOGCYAMdqzQ@mail.gmail.com>
	<1463614.KLCBsoWyCC@sifl>
Date: Wed, 8 Aug 2012 17:09:20 -0400
Message-ID: <CACLa4pvO4C9wUFXMp66CKw0gjXPyyVyik6gGtuAdDY-P5syYNA@mail.gmail.com>
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
From: Eric Paris <eparis@parisplace.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 5:03 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Wednesday, August 08, 2012 04:51:56 PM Eric Paris wrote:

>> Could we add a __init function which does the security_sk_alloc() in
>> the same file where we declared them?
>
> Is it safe to call security_sk_alloc() from inside another __init function?  I
> think in both the case of SELinux and Smack it shouldn't be a problem, but I'm
> concerned about the more general case of calling a LSM hook potentially before
> the LSM has been initialized.
>
> If that isn't an issue we could probably do something in ip_init().

The security_initcall() functions should happen way before __init
functions.  If an LSM busts, it's the LSM initializing itself too late
not the code here being wrong...
