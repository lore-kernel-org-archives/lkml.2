Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0K3Qm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:42:29 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:47975 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0K3Qm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:42:28 -0500
Date: Tue, 30 Nov 2010 18:42:25 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, WANG Cong <amwang@redhat.com>
Subject: Re: [PATCH] headers_check: better search for functions in headers
Message-ID: <20101130164225.GH26184@shisha.kicks-ass.net>
References: <1291134119-12903-1-git-send-email-virtuoso@slind.org>
 <20101130083607.3e1e6ec5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130083607.3e1e6ec5.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 08:36:07AM -0800, Randy Dunlap wrote:
> On Tue, 30 Nov 2010 18:21:59 +0200 Alexander Shishkin wrote:
> 
> > Some headers don't bother with "extern" in function prototypes,
> > which results in said prototypes being unnoticed and exported
> > to userland.
> > 
> > This patch slightly improves detection of such cases by checking
> > for C type names as well in the beginning of a line.
> > 
> > Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> > CC: Stephen Hemminger <shemminger@vyatta.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Michal Marek <mmarek@suse.cz>
> > CC: WANG Cong <amwang@redhat.com>
> > CC: linux-kernel@vger.kernel.org
> > ---
> >  scripts/headers_check.pl |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> > index 50d6cfd..e0e25a1 100644
> > --- a/scripts/headers_check.pl
> > +++ b/scripts/headers_check.pl
> > @@ -64,7 +64,7 @@ sub check_include
> >  
> >  sub check_declarations
> >  {
> > -	if ($line =~m/^\s*extern\b/) {
> > +	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
> >  		printf STDERR "$filename:$lineno: " .
> >  		              "userspace cannot call function or variable " .
> 
> s/call/reference/ ?

Yes, there's a mistake there, but it's unrelated to this patch.
Maybe goes in another patch?

Regards,
--
Alex
