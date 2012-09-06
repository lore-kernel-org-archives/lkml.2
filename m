Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab2IFPr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab2IFPrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:47:53 -0400
Date: Thu, 6 Sep 2012 11:47:49 -0400
From: Dave Jones <davej@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com
Subject: Re: Check all returns from audit_log_start
Message-ID: <20120906154749.GA27399@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Paris <eparis@parisplace.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com
References: <20120906134628.GA8962@redhat.com>
 <20120906150838.GA23345@redhat.com>
 <CACLa4pteVcrk0ZuhUDQOf=WMx1Odob5F+B=Y=Y3DT-mj9ZbQ6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLa4pteVcrk0ZuhUDQOf=WMx1Odob5F+B=Y=Y3DT-mj9ZbQ6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 11:36:06AM -0400, Eric Paris wrote:
 > On Thu, Sep 6, 2012 at 11:08 AM, Dave Jones <davej@redhat.com> wrote:
 > > Following on from the previous patch that fixed an oops, these
 > > are all the other similar code patterns in the tree with the same
 > > checks added.  I never saw these causing problems, but checking
 > > this everywhere seems to make more sense than every subsequent
 > > routine that gets passed 'ab' having to check it.
 > >
 > > Later we could remove all those same checks from audit_log_format
 > > and friends. For now, this just prevents similar bugs being introduced
 > > as the one in my previous patch.
 > >
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > Not certain because I haven't looked at what happens with the error
 > code, but I think this might not be right.  auditd can be explictly
 > told not to audit certain events, in which case it is normal and
 > expected that ab would come back NULL....

Ugh, that's a lot messier to have to audit every function that gets
passed 'ab' to make sure it has a NULL check, but ok I'll go look at it.

hopefully audit_log_link_denied was a one off.

	Dave

