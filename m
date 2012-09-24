Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab2IXTEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab2IXTEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:04:09 -0400
Date: Mon, 24 Sep 2012 15:04:04 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 5/6] dyndbg: in dynamic_emit_prefix, change inter-field
 separator
Message-ID: <20120924190403.GG2492@redhat.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
 <1348011407-24108-6-git-send-email-jim.cromie@gmail.com>
 <1348023402.11276.5.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348023402.11276.5.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 07:56:42PM -0700, Joe Perches wrote:
> On Tue, 2012-09-18 at 17:36 -0600, Jim Cromie wrote:
> > dynamic_emit_prefix() currently separates modname, funcname, lineno
> > with ':'.  This is confounds use of cut -d: <logfile>, since the field
> > positions can change per callsite with dynamic-debug.  So change
> > inter-field separator to '.' and keep the ':' prefix terminator.
> > 
> > This improves the situation, but doesnt solve it entirely; if
> > dyndbg==p is used instead of dyndbg==p[fmlt]+, the callsite is enabled
> > but no prefix is added, so theres one less ':' in the message.
> > Changing the terminator to ',' would fix this, and might be warranted,
> > especially since pr_fmt() typically adds a ':' as well.
> > 
> > Joe Perches wasnt a fan of this, but his complaint was essentially
> > that cut -d: was a poor way to do this kind of thing.  I concede that
> > point, but note that the kernel is not in the habit of needlessly
> > confounding users work, at least when accommodating them is so trivial.
> 
> And I still think this is ugly as it requires different parsing
> by scripts when using combinations of +pfmlt
> 
> 

If this patch doesn't 'solve it entirely', I'm reluctant to ack it,
Would brackets, such as {} around the optional prefix be reasonable?

Thanks,

-Jason
