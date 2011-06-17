Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab1FQPvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:51:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37127 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1FQPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LQ/cYN7OJCZK/dj1oQ4CJk/mlpih7hy5Ox006msmHt7E4KzWN1z6YQXvIwWzPjBkx3
         /Sto6/FXGahaEx3qwPZcsqCazUVTbQaESlrHUUNvRf2La5sa26xm80l22l8o+xDCij+a
         P6ejuH59ouM69TTBR2ThifWulupuvUKlGLdjY=
Date: Fri, 17 Jun 2011 19:50:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        apparmor@lists.ubuntu.com,
        "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        kernel-hardening@lists.openwall.com
Subject: Re: [RFC v1] security: introduce ptrace_task_access_check()
Message-ID: <20110617155058.GB22588@albatros>
References: <20110617152912.GA21885@albatros>
 <4DFB7605.9000909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB7605.9000909@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:43 -0400, Eric Paris wrote:
> >Please help me to figure out how such patch should be divided to be
> >applied.  I think about such scheme:
> >
> >1) add generic security/* functions.
> >2-4) add ptrace_task_access_check() for SMACK, AppArmor and SELinux.
> >5) change ptrace_access_check() in security ops and all LSMs to
> >     ptrace_task_access_check().
> >
> >But I'd like to hear maintainers' oppinions not to put useless efforts.
> 
> Not a real review, but I didn't instantly grok the need for the new
> cap functions.

It is needed because of capable(CAP_SYS_PTRACE) and similar inside of
ptrace_may_access() implementations.

>  So maybe that's it's own patch with it's own change
> log.  After that you should just add the 'parent' task to
> ptrace_access_check() and fix all of the LSMs to handle the new
> semantics at once.  No need to rename the function or do a bunch of
> seperate patchs.

I thought it would represent function's semantic changes more strongly.

>  All of us LSM authors can just ACK our little part
> and James can take the patch when everyone has their say.  I think
> that will make history the cleanest.....

Great!  It would be much simple for me too :)

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
