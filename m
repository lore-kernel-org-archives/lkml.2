Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1DGPEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:04:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1DGPEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:04:05 -0400
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D9DD08C.2080101@zytor.com>
References: <4D9CE4AE.4090303@zytor.com> <1302185312.3329.1240.camel@twins>
	 <4D9DCDAB.9000707@zytor.com> <1302188050.9086.27.camel@twins>
	 <4D9DD08C.2080101@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Apr 2011 17:03:55 +0200
Message-ID: <1302188635.9086.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 07:56 -0700, H. Peter Anvin wrote:
> On 04/07/2011 07:54 AM, Peter Zijlstra wrote:
> > 
> > Can't we use a prepare-commit-msg or commit-msg hook to re-write the
> > commit message to include a Link tag when one is missing, using
> > something like:
> > 
> > Link: http://lkml.kernel.org/r/tip-$SHA@git.kernel.org
> > 
> > And have the post-commit hook that sends the messages recognize this
> > form and send the message using the correct msgid.
> > 
> > That way the commit includes a correct and clickable link, doesn't
> > require magic knowledge and doesn't need the committer to do extra work.
> > 
> 
> Think about it... hint: the SHA1 is a cryptographically secure signature
> of the commit object.

D'0h ok.. but the scheme would work with any generated msgid, all we
need is to generate one for commits that lack a Link tag and insert it
using the prepare-commit-msg/commit-msg hooks and for the post-commit
hook to recognize it and use that actual msgid.

The only thing to avoid is msgid collision, but given that MUAs already
have this problem all we need to do is borrow some of their logic.
