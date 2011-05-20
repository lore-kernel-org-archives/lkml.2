Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935407Ab1ETI43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:56:29 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:59962 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897Ab1ETI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:56:26 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Fri, 20 May 2011 09:56:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105200000.18310.pedro@codesourcery.com> <201105200344.44520.vda.linux@googlemail.com>
In-Reply-To: <201105200344.44520.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105200956.23320.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 02:44:44, Denys Vlasenko wrote:
> > > > In GDBs case, GDB will want to poke at memory
> > > > right after attaching
> > > 
> > > ...where "right after attaching" is defined as "when the first ptrace-stop
> > > is reported". Which will happen very soon.
> > 
> > Hmm?  Why would it happen very soon?
> > Isn't the point of SEIZE not 
> > interrupting that you'd not get any INTERRUPT or stop at all?
> > Where is the ptrace-stop coming from?
> 
> From PTRACE_INTERRUPT. Without it, tracee is running. 

> Ptrace API never allowed poking of running tracees.

Which is a bit lame.

> You need to stop it first.

That was my point...  I was just pointing out that GDB will end
up PTRACE_INTERRUPTing the target anyway.  Maybe we could extend
GDB's "observer" mode to be even more observer-only, and delay
reading the DSO list and whatever else GDB does on attach until
the first stop, or to user request.  Some archs need reading
registers as soon as possible in order to actually know which
arch variant we've attached to.  Anyway, this is GDBs business.
SEIZE not interrupting won't hurt GDB, and is obviously useful for
some use cases and tracers, _provided the race with SETOPTS is fixed_.

-- 
Pedro Alves
