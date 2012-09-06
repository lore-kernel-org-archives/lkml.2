Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab2IFPgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:36:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45376 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2IFPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:36:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120906150838.GA23345@redhat.com>
References: <20120906134628.GA8962@redhat.com>
	<20120906150838.GA23345@redhat.com>
Date: Thu, 6 Sep 2012 11:36:06 -0400
Message-ID: <CACLa4pteVcrk0ZuhUDQOf=WMx1Odob5F+B=Y=Y3DT-mj9ZbQ6A@mail.gmail.com>
Subject: Re: Check all returns from audit_log_start
From: Eric Paris <eparis@parisplace.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 11:08 AM, Dave Jones <davej@redhat.com> wrote:
> Following on from the previous patch that fixed an oops, these
> are all the other similar code patterns in the tree with the same
> checks added.  I never saw these causing problems, but checking
> this everywhere seems to make more sense than every subsequent
> routine that gets passed 'ab' having to check it.
>
> Later we could remove all those same checks from audit_log_format
> and friends. For now, this just prevents similar bugs being introduced
> as the one in my previous patch.
>
> Signed-off-by: Dave Jones <davej@redhat.com>

Not certain because I haven't looked at what happens with the error
code, but I think this might not be right.  auditd can be explictly
told not to audit certain events, in which case it is normal and
expected that ab would come back NULL....
