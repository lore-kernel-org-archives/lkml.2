Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab2CWAKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:10:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:43596 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab2CWAKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:10:38 -0400
Message-ID: <1332461414.2982.90.camel@pasglop>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Date: Fri, 23 Mar 2012 11:10:14 +1100
In-Reply-To: <4F688F48.6090303@redhat.com>
References: <4F688F48.6090303@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 16:08 +0200, Avi Kivity wrote:
> Linus, please pull from
> 
>   ra.kernel.org:/pub/scm/virt/kvm/kvm.git kvm-updates/3.4
> 
> (ssh URL as git.kernel.org is down at the moment) to receive the KVM
> updates for the 3.4 merge window.  Changes include  timekeeping
> improvements, support for assigning host PCI devices that share
> interrupt lines, s390 user-controlled guests, a large ppc update, and
> random fixes.

I wonder if Linus missed this one ... :-)

But that's not the point of the email ... Avi, I have a bit of a problem
with the way you manage your tree(s).

It appears to me that you have on one side, a tree that has all of KVM
dev. history for years, which is used as a parent by your
sub-maintainers such as Alex, and as your main dev. tree. However, that
-tree- is not related to Linus, and whenever you do a pull request, you
basically rebase patches on top of a different tree which is derived
from Linus.

That means that everything gets constantly rebased, and it makes life
very much harder for us working with this.

For our own dev, we have to essentially work on trees that derive from
Linus, my own -next branch, Alex's -next branch, whatever you have going
on etc... and updating/rebasing our own local WIP patches is extremely
painful because there is never a recent common ancestor between your
trees (and other deriving from it such as Alex) and anything else.

Is there any reason why you keep working that way other than a bad
habit ? :-)

It would be much easier for everybody involved if your WIP development
was always based on a recent ancestor and that you did not rebase it,
meaning that Linus would just "pull" it and everybody would resync
cleanly after every merge window.

Cheers,
Ben.


