Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1FRJEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 05:04:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1FRJEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 05:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g5KuCt+eCASgwjhCCAts/5tUySja9tmG184vqC1zSPGsy1SXIPMyoP39Has0RBsVa5
         7bM4VsUXKWch70Seg6wsJk+/7aM7w1Sn7YPh02rIb6P24SrLBP9xIgcEwdfrLnU6g4ry
         2KPElCR4WJfQ/vIQb/RswlMk09vd7bvCSLSHo=
Date: Sat, 18 Jun 2011 11:04:31 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Message-ID: <20110618090431.GL2611@htj.dyndns.org>
References: <1308043218-23619-1-git-send-email-tj@kernel.org>
 <201106180959.38847.vda.linux@googlemail.com>
 <20110618083559.GK2611@htj.dyndns.org>
 <201106181057.02477.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106181057.02477.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jun 18, 2011 at 10:57:02AM +0200, Denys Vlasenko wrote:
> I explained this already. strace code is a bit complex, and adding
> more complexity so that it uses PTRACE_SEIZE if available, but PTRACE_ATTACH
> if it is not, will add some PITA.
> 
> Considering that strace does not want PTRACE_SEIZE per se, it only wants
> to have a way to properly see and handle group stops, having an option
> to enable *only that functonality* without having to use PTRACE_SEIZE
> will be useful for strace.

I understand that it would make strace's life somewhat easier but
don't agree the difference is significant enough to justify
introducing more options.  We're talking about small number of well
defined behaviors.  Yes, it wouldn't be as simple as adding several
liners during initialization but that doesn't warrant extra kernel
features and differing behaviors which, I think, in the long run, make
things much more complicated (not complex) than necessary.

Thanks.

-- 
tejun
