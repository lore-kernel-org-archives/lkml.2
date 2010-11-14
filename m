Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0KNFJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:09:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44890 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0KNFJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:09:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org
In-Reply-To: <877hgmr72o.fsf@gmail.com>
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com> <877hgmr72o.fsf@gmail.com>
Message-Id: <20101114140920.E013.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:09:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue,  9 Nov 2010 16:28:02 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > So, I don't think application developers will use fadvise() aggressively
> > because we don't have a cross platform agreement of a fadvice behavior.
> > 
> I strongly disagree. For a long time I have been trying to resolve
> interactivity issues caused by my rsync-based backup script. Many kernel
> developers have said that there is nothing the kernel can do without
> more information from user-space (e.g. cgroups, madvise). While cgroups
> help, the fix is round-about at best and requires configuration where
> really none should be necessary. The easiest solution for everyone
> involved would be for rsync to use FADV_DONTNEED. The behavior doesn't
> need to be perfectly consistent between platforms for the flag to be
> useful so long as each implementation does something sane to help
> use-once access patterns.
> 
> People seem to mention frequently that there are no users of
> FADV_DONTNEED and therefore we don't need to implement it. It seems like
> this is ignoring an obvious catch-22. Currently rsync has no fadvise
> support at all, since using[1] the implemented hints to get the desired
> effect is far too complicated^M^M^M^Mhacky to be considered
> merge-worthy. Considering the number of Google hits returned for
> fadvise, I wouldn't be surprised if there were countless other projects
> with this same difficulty. We want to be able to tell the kernel about
> our useage patterns, but the kernel won't listen.

Because we have an alternative solution already. please try memcgroup :)



