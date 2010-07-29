Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0G2Jfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:35:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46982 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0G2Jfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qr/oiFWAE+NgSOex6qu24Kb9nPJ23YtBT2Y5gZHTZnZaRu1XjwDqgYymmGQ0/3aPJV
         WTEjr+PDbXQ3GDkBjG41Dc08Tygv4N6ZFVNPz9Pf1KL7Qg1J5StaOSyRqiiat/1SKsf1
         N6osPAXeQjYwXN5GqSOlt+nH6mdC6nq/XN2jo=
Date: Thu, 29 Jul 2010 13:35:11 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
Message-ID: <20100729093511.GB7143@albatros>
References: <1280335185-23265-1-git-send-email-segooon@gmail.com>
 <4C5063D4.4070108@linux.intel.com>
 <20100728171327.GA24149@albatros>
 <4C5066CB.7010009@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5066CB.7010009@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 19:20 +0200, Andi Kleen wrote:
> 
> >I'm agree with you that if allocation fails at boot time, we are dead :)
> >But this coding style breaking rules that result from some functions
> >_must_ be checked for errors. Maybe we should add BUG_ON() here or
> >indicate someway that we have no ideas how to handle error?
> 
> What rules exactly? I don't think any of those functions are
> declared with __must_check

IMO memmory allocation fails are dangerous in kernel mode. As it is
probably not exploitable because of boot time, it can destroy some
sensitive data like dirty disk caches those are going to be written on
disk.

> 
> Coding style should never get in the way of what is right.
> 
> The classic way to explicitely discard a return value is a cast to
> void, but that is generally considered
> ugly in the Linux kernel.
> 
> One could possibly add a comment about this at least.
> 
> -Andi
> 
