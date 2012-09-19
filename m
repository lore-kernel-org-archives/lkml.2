Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2ISC4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:56:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50325 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750908Ab2ISC4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:56:43 -0400
Message-ID: <1348023402.11276.5.camel@joe2Laptop>
Subject: Re: [PATCH 5/6] dyndbg: in dynamic_emit_prefix, change inter-field
 separator
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 18 Sep 2012 19:56:42 -0700
In-Reply-To: <1348011407-24108-6-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
	 <1348011407-24108-6-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 17:36 -0600, Jim Cromie wrote:
> dynamic_emit_prefix() currently separates modname, funcname, lineno
> with ':'.  This is confounds use of cut -d: <logfile>, since the field
> positions can change per callsite with dynamic-debug.  So change
> inter-field separator to '.' and keep the ':' prefix terminator.
> 
> This improves the situation, but doesnt solve it entirely; if
> dyndbg==p is used instead of dyndbg==p[fmlt]+, the callsite is enabled
> but no prefix is added, so theres one less ':' in the message.
> Changing the terminator to ',' would fix this, and might be warranted,
> especially since pr_fmt() typically adds a ':' as well.
> 
> Joe Perches wasnt a fan of this, but his complaint was essentially
> that cut -d: was a poor way to do this kind of thing.  I concede that
> point, but note that the kernel is not in the habit of needlessly
> confounding users work, at least when accommodating them is so trivial.

And I still think this is ugly as it requires different parsing
by scripts when using combinations of +pfmlt


