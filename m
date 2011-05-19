Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab1ESORe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:17:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378Ab1ESORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CV16FjC7L6wR/t40m8HM8ta1FGB3JZl79mzB24n/0MMlERv5bdD3KWvj9kneYkW1UB
         HE6yu684zesoK7Htya0C5dX81seOHWar5YaQKmb+BVFZMVZ8ZgPdVBzcnn5+hDY7Ms/7
         TdMsC4ytEVGGKTJHm9zYAq91ejtIqc6gzja0g=
Date: Thu, 19 May 2011 16:17:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110519141728.GJ627@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518095539.GU20624@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 18, 2011 at 11:55:39AM +0200, Tejun Heo wrote:
> I've been thinking about Jan's suggestion to make ATTACH and DETACH
> not require tracee to trap.  We already have this for DETACH for cases
> where the tracer is killed and it seems it wouldn't be too difficult
> to make that happen for ATTACH either and for that to be truly useful
> I suppose PTRACE_SETOPTIONS shouldn't require trapped state either.
> Jan, would that be enough for the use cases you have on mind?

I've been trying this and clean DETACH requires the tracee to be
trapped (or not running).  The arch detach hook, which BTW is not
executed when the tracer is killed, modifies tracee state expecting it
to be off-cpu.

But making SEIZE not trigger INTERRUPT and SETOPTIONS without
requiring TRACED don't seem too difficult.  Jan, would that be enough?
Oleg, what do you think?

Thanks.

-- 
tejun
