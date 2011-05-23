Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1EWNLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:11:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab1EWNLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:11:22 -0400
Date: Mon, 23 May 2011 15:09:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110523130946.GB7232@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org> <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org> <20110519141728.GJ627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519141728.GJ627@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Tejun Heo wrote:
>
> Hello,
>
> On Wed, May 18, 2011 at 11:55:39AM +0200, Tejun Heo wrote:
> > I've been thinking about Jan's suggestion to make ATTACH and DETACH
> > not require tracee to trap.  We already have this for DETACH for cases
> > where the tracer is killed and it seems it wouldn't be too difficult
> > to make that happen for ATTACH either and for that to be truly useful
> > I suppose PTRACE_SETOPTIONS shouldn't require trapped state either.
> > Jan, would that be enough for the use cases you have on mind?
>
> I've been trying this and clean DETACH requires the tracee to be
> trapped (or not running).  The arch detach hook, which BTW is not
> executed when the tracer is killed, modifies tracee state expecting it
> to be off-cpu.

Argh. Yes, ptrace_disable() is the problem, I didn't think about it :/

Oleg.

