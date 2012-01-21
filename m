Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2AUTpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:45:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35306 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751015Ab2AUTpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:45:52 -0500
Message-ID: <1327175138.2050.21.camel@joe2Laptop>
Subject: Re: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
From: Joe Perches <joe@perches.com>
To: sam hansen <solid.se7en@gmail.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 21 Jan 2012 11:45:38 -0800
In-Reply-To: <CAEMzQTZZnPfGK4CZGw+PraL59f4C8eADfvpaGUrVd38d5TFA+A@mail.gmail.com>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
	 <1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
	 <1327164143.2050.9.camel@joe2Laptop>
	 <CAEMzQTZZnPfGK4CZGw+PraL59f4C8eADfvpaGUrVd38d5TFA+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-21 at 11:22 -0800, sam hansen wrote:
> > One other thing.  It would be better to add
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > before any #include and convert all the
> > printks(KERN_<LEVEL> to pr_<level>(
> > stripping all the leading XGIfb: too.
> 
> So, an administrative question.  Sorry for my noob-ishness but... I
> will be 1) modifying the patch regarding prink to use pr_LVL (and a
> few logic tweaks), and will also be introducing a new patch to set up
> the pr_fmt macro for kbuild.  I can find lots of information regarding
> how to create/submit a patch, but not a lot of information about how
> to modify/resubmit a patch you've already submitted and received
> feedback for.

Rework the commented things in a new branch.

Apply the patches to the new branch one at
a time, modify as necessary then
git commit --amend
the appropriately changed files while modifying
change logs.

Then resubmit with
	git format-patch --subject-prefix="PATCH V2"
You could also add --in-reply-to=originalemailid

> The pr_fmt patch will likely just be a new patch outside of this patch
> set? 

A new patch would be fine.
Here's a little regex based tool for part of that conversion
http://lwn.net/Articles/380161/

An example would be:
$ ./scripts/cvt_kernel_style.pl			\
	--convert=convert_printk_to_pr_level	\
	-o drivers/staging/xgifb/XGI_main_26.c


