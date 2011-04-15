Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1DORaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:30:15 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:33072 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1DORaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:30:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 3/5] 9p: revert tsyncfs related changes
In-Reply-To: <AANLkTik1nw839sfza143jRgc3_w6dDtrxUC+_w7O3Okn@mail.gmail.com>
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1301052651-21440-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4D8D0704.7080106@linux.vnet.ibm.com> <877hbl0xxq.fsf@linux.vnet.ibm.com> <4D8FB93A.6020508@linux.vnet.ibm.com> <AANLkTik1nw839sfza143jRgc3_w6dDtrxUC+_w7O3Okn@mail.gmail.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Fri, 15 Apr 2011 23:00:03 +0530
Message-ID: <87oc474e3o.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 11:05:08 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On Sun, Mar 27, 2011 at 5:24 PM, Venkateswararao Jujjuri
> <jvrao@linux.vnet.ibm.com> wrote:
> >
> > Nice explanation. I looked at NFS and realized that they also follow
> > write_inode approach.
> > So I think you should make it explict that this will be helpful to dotl
> > also and may and TFSYNCFS
> > in the future if needed. With that I ack this.
> >
> 
> If this is something we really think we'll be adding back in the
> future, is there someway we can conditionalize its use (default off
> perhaps) so that if a particular server wanted to take advantage of
> it, they could.  This would seem preferable to just backing out the
> whole patch.

It would be a nice feature to request the server for feature bits and
then use different 9p operations with .L. ie if we can query the server
and find out whether it supports tsyncfs then we can probably skip fsync
during write_inode. The feature set is also useful to figure out which
acl model the client should enforce if we start supporting multiple acl
models and also to find out whether server also acl evaluation.
So i guess we should do this once we have something similar to
TFEATURE 9p operation

> 
> Another aspect which I didn't consider when we added it is what it
> would do to older versions of the servers which didn't have TFSYNCFS
> -- maybe this is a good case study for the .L graceful degredation
> plan we had talked about in the past where you try a tfsyncfs and if
> the server returns an error that it doesn't implement it you back off
> to another solution.
> 

With the current Qemu server, the server aborts when it gets a 9p
request that it didn't implement. That need to be fixed. Do you like to
see the above done as a part of new set of operations that we are going
to do, or are you suggesting that we need to do it for the existing set
looking at when we added the 9p operations ?.

-aneesh
