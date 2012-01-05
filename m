Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2AEEUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 23:20:09 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51018 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab2AEEUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 23:20:05 -0500
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 23:17:12 -0500
In-Reply-To: <20120105020639.GA1161@kroah.com>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
	 <1324560391.1964.8.camel@falcor>
	 <20120104152801.d8f555ca.akpm@linux-foundation.org>
	 <1325723630.13419.2.camel@falcor>
	 <20120104164638.cc21fc2e.akpm@linux-foundation.org>
	 <20120105020639.GA1161@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1325737033.13419.43.camel@falcor>
Mime-Version: 1.0
x-cbid: 12010504-6148-0000-0000-000002685538
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 18:06 -0800, Greg KH wrote:
> On Wed, Jan 04, 2012 at 04:46:38PM -0800, Andrew Morton wrote:
> > On Wed, 04 Jan 2012 19:33:49 -0500
> > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > 
> > > On Wed, 2012-01-04 at 15:28 -0800, Andrew Morton wrote:
> > > > On Thu, 22 Dec 2011 08:26:30 -0500
> > > > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > On Thu, 2011-12-22 at 12:54 +0200, Dmitry Kasatkin wrote:
> > > > > > When a file is truncated with truncate()/ftruncate() and then closed,
> > > > > > iversion is not updated. This patch uses ATTR_SIZE flag as an indication
> > > > > > to increment iversion.
> > > > > > 
> > > > > > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > > > > 
> > > > > Acked-by: Mimi Zohar <zohar@us.ibm.com> 
> > > > > (Stable should be cc'ed on this patch.)
> > > > 
> > > > why?
> > > 
> > > Why backported?
> > 
> > Yes.  If you want to submit the patch to the -stable maintainer then
> > you should explain to him why the fix is important enough to warrant
> > doing that.  That involves explaining the user-visible effects of
> > the bug.
> > 
> > >  The IMA measurement list could be incomplete.
> > 
> > In more detail than this.  Maybe he knows what the above sentence
> > means, but I sure don't.
> 
> Nope, I don't either :)

On fput(), i_version is used to detect and flag files that have changed
and need to be re-measured in the IMA measurement policy.  When a file
is truncated with truncate()/ftruncate() and then closed, i_version is
not updated.  As a result, although the file has changed, it will not be
re-measured and added to the IMA measurement list on subsequent access.

Mimi

