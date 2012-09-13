Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2IMEu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:50:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46763 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2IMEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:50:56 -0400
Message-ID: <5051662E.1040908@wwwdotorg.org>
Date: Wed, 12 Sep 2012 22:50:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: code clean up
References: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com> <5050D034.7030203@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6DDEFB8D7B@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB8D7B@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 09:42 PM, Venu Byravarasu wrote:
> Stephen Warren wrote at Wednesday, September 12, 2012 11:41 PM:
>> On 09/12/2012 01:02 AM, Venu Byravarasu wrote:
>>> As part of code clean up, used devm counterparts for the APIs
>>> possible.
>>
>> Almost all of this patch has already been applied as:
> 
> Agree. 
> Currently Balbi's tree has bit old ehci-tegra.c.

Quite possibly. That would happen if patches to ehci-tegra.c were
checked into other branches, which have not yet been merged to Linus's
tree, and hence have not made it into the baseline for Felipe's tree.
This is especially likely as ehci-tegra.c isn't something that Felipe's
xceiv branch would usually take patches for IIRC.

> Because of this the patches prepared with linux-next need to be rebased onto this tree and prepare a new patch.
> My main intention behind pushing this patch was to get all changes of ehci-tegra.c from linux-next into balbi's code base so that I can push the same patch against either balbi's tree or linux-next.

That's not the way the Linux branching model works. The primary way for
Felipe's branch to pick up changes from another branch is for the other
branch to be merged by Linus, and then Felipe to either merge Linus's
branch into his, or start a new branch based on a more recent tag from
Linus's tree. If you send patches to Felipe that duplicate work that's
already happened in another branch, you'll most likely end up causing
merge conflicts when Felipe's branch is merged with the other branch
containing the same work in linux-next, Greg's USB tree, and Linus's
tree. Of course, you might get lucky and avoid conflicts if the patches
are identical, but duplicate patches are still not a good idea.

It's best if you send patches that apply and operate correctly on one
particular branch, e.g. just Felipe's or some other USB
(sub-)maintainer's branch.

If your patches actually rely on changes from multiple different
branches, then that is problematic. The simplest answer is to simply
wait for the (end of the) next kernel merge window when everything has
been merged together, and then start sending patches based on the merged
result.

In some cases, branches can be merged together other than by Linus,
although you do have to be quite careful to avoid pain when doing this.
It's best to plan out what patches you'll send, where you expect they
will be applied, and point out any such dependencies to the maintainers
ahead of time. Developing all your big patches first and then sending
them, rather than developing them piecemeal, may help you plan this out
better, at least at first.
