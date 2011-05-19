Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1ESQoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:44:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38454 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1ESQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xlVmoxmOcn2EPXSy2s3X2lGS4Isj7CcsuKUBUnRdVmcEE6+CJVU47aVnX78MVgfT3t
         3/oUoEA7oJe2sE4QiOTXdVqqDCRObHTEKNOneqbd+s0mO/Av8SxO4VGTVwgcJwlFFz2Q
         TESR17EipJmk86M/G2ZzLhDYMOaRl2xz2jgHk=
Date: Thu, 19 May 2011 18:44:02 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 09/10] ptrace: add JOBCTL_BLOCK_NOTIFY
Message-ID: <20110519164402.GO627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-10-git-send-email-tj@kernel.org>
 <20110519163233.GE17265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519163233.GE17265@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 19, 2011 at 06:32:33PM +0200, Oleg Nesterov wrote:
> > +	/*
> > +	 * Make sure @chlid is still ptraced by us and clear BLOCK_NOTIFY.
> > +	 */
> > +	if (likely((child->ptrace & PT_PTRACED) && child->parent == current))
> 
> This looks a bit confusing... It is either traced or not. If it is traced,
> nobody else can trace it. In fact even PT_PTRACED is not strictly needed
> but I agree this check makes the code cleaner.

Hmmm... I suppose we can make the error paths finer grained so that
attach failure doesn't end up calling ptrace_put_task_struct() but I
think it would be better to keep the two tests there so that the
function can be called regardless of what happened.

Thanks.

-- 
tejun
