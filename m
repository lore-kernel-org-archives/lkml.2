Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1F1Ml5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:41:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41366 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1F1Mi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:38:28 -0400
Date: Tue, 28 Jun 2011 14:38:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110628123823.GD3386@htj.dyndns.org>
References: <201106262108.43011.vda.linux@googlemail.com>
 <20110626200442.GA16293@redhat.com>
 <20110627081139.GY30101@htj.dyndns.org>
 <20110627134713.GB3527@redhat.com>
 <20110627135252.GB30101@htj.dyndns.org>
 <20110627151827.GA6223@redhat.com>
 <20110628082512.GA3386@htj.dyndns.org>
 <BANLkTik2KqKGwBAqN+CSz7_ergx5VM9x4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik2KqKGwBAqN+CSz7_ergx5VM9x4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 28, 2011 at 02:30:36PM +0200, Denys Vlasenko wrote:
> On Tue, Jun 28, 2011 at 10:25 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Mon, Jun 27, 2011 at 05:18:27PM +0200, Oleg Nesterov wrote:
> > Yeah, but that's a pretty silly way to do it.  If we make it depend on
> > PT_SEIZED, we can simply say "if seized, EXEC reports..." but as it
> > currently stands, it would go like "If the message is non-zero on
> > EXEC, it indicates...  This behavior is valid since kernel version
> > x.x.x".
> 
> This is true for any new addition to API.
> It starts from some kernel version.

Hmmm... but as I wrote above, we have a choice to make here and the
two options are clearly different?

> > Maybe adding a guarantee that PTRACE_SEIZE capable kernel
> > always reports the old pid on EXEC but that would still seem
> > unnecessarily complicated.  It isn't a bug fix.  I don't see much
> > point in introducing new behavior separately.
> 
> This new feature looks orthogonal to PTRACE_SEIZE to me.

Yeah, sure, but we're bundling a number of behavior changes with
PT_SEIZED because it's impractical to introduce each with its own
compatibility / feature test bits, so it makes sense to do the same
with this one, I think.  It's not like there's a lot to gain by
supporting this outside of SEIZE anyway.

Thanks.

-- 
tejun
