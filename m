Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2AESjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:39:45 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47006 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790Ab2AESjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:39:43 -0500
Message-ID: <1325788781.2775.12.camel@dabdike.Larkspurhotels.com>
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 10:39:41 -0800
In-Reply-To: <1325783951.23566.52.camel@falcor>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
	 <1324560391.1964.8.camel@falcor>
	 <20120104152801.d8f555ca.akpm@linux-foundation.org>
	 <1325723630.13419.2.camel@falcor>
	 <20120104164638.cc21fc2e.akpm@linux-foundation.org>
	 <20120105020639.GA1161@kroah.com> <1325737033.13419.43.camel@falcor>
	 <20120105165412.GE26153@kroah.com> <1325783951.23566.52.camel@falcor>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 12:19 -0500, Mimi Zohar wrote:
> On Thu, 2012-01-05 at 08:54 -0800, Greg KH wrote:
> > On Wed, Jan 04, 2012 at 11:17:12PM -0500, Mimi Zohar wrote:
> > > On Wed, 2012-01-04 at 18:06 -0800, Greg KH wrote:
> > > > On Wed, Jan 04, 2012 at 04:46:38PM -0800, Andrew Morton wrote:
> > > > > On Wed, 04 Jan 2012 19:33:49 -0500
> > > > > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > On Wed, 2012-01-04 at 15:28 -0800, Andrew Morton wrote:
> > > > > > > On Thu, 22 Dec 2011 08:26:30 -0500
> > > > > > > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > > > > > 
> > > > > > > > On Thu, 2011-12-22 at 12:54 +0200, Dmitry Kasatkin wrote:
> > > > > > > > > When a file is truncated with truncate()/ftruncate() and then closed,
> > > > > > > > > iversion is not updated. This patch uses ATTR_SIZE flag as an indication
> > > > > > > > > to increment iversion.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > > > > > > > 
> > > > > > > > Acked-by: Mimi Zohar <zohar@us.ibm.com> 
> > > > > > > > (Stable should be cc'ed on this patch.)
> > > > > > > 
> > > > > > > why?
> > > > > > 
> > > > > > Why backported?
> > > > > 
> > > > > Yes.  If you want to submit the patch to the -stable maintainer then
> > > > > you should explain to him why the fix is important enough to warrant
> > > > > doing that.  That involves explaining the user-visible effects of
> > > > > the bug.
> > > > > 
> > > > > >  The IMA measurement list could be incomplete.
> > > > > 
> > > > > In more detail than this.  Maybe he knows what the above sentence
> > > > > means, but I sure don't.
> > > > 
> > > > Nope, I don't either :)
> > > 
> > > On fput(), i_version is used to detect and flag files that have changed
> > > and need to be re-measured in the IMA measurement policy.  When a file
> > > is truncated with truncate()/ftruncate() and then closed, i_version is
> > > not updated.  As a result, although the file has changed, it will not be
> > > re-measured and added to the IMA measurement list on subsequent access.
> > 
> > And what am I supposed to do with this?
> > 
> > Please, go read Documentation/stable_kernel_rules.txt for how to
> > properly submit patches to the stable kernel tree.  The information here
> > needs to be in the patch changelog itself, not in some random email
> > thread that will get lost instantly into my email-archive-from-hell
> > after I am done reading this.
> > 
> > greg k-h
> 
> Yes, I've read Documentation/stable_kernel_rules.txt and think this
> patch meets the criteria for being backported.
> 
> As far as I'm aware, this patch hasn't been upstreamed yet and is
> waiting for someone, besides myself, to Ack it.  Once Acked, either
> Dmitry or I can send a pull request with an updated patch description.
> Should this patch go in via the security tree?

If it hasn't been upstreamed yet, just make sure you put

cc: stable@kernel.org

In the signoffs of the patch you're sending upstream and the backport
will occur automatically when the patch is finally upstreamed.

James


