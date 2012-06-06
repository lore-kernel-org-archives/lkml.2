Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab2FFSAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:00:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37380 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2FFSA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:00:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FCF9053.6020102@codeaurora.org>
References: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
	<4FCF9053.6020102@codeaurora.org>
Date: Wed, 6 Jun 2012 11:00:27 -0700
X-Google-Sender-Auth: By2sJajtb08fuM7G1nwEBiWzfVQ
Message-ID: <CAEYUcX33J4VjFOc1qLi7TZQ6B8ugc0Yky=pm1yPJXqi=SfZPBA@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: Add ramoops support for the Flattened Device Tree.
From: Bryan Freed <bfreed@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        marco.stornelli@gmail.com, grant.likely@secretlab.ca,
        anton.vorontsov@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 10:16 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
> On 06/05/12 12:59, Bryan Freed wrote:
> > When called with a non-zero of_node, fill out a new
> > ramoops_platform_data
> > with data from the specified Flattened Device Tree node.
> > Update ramoops documentation with the new FDT interface.
> >
> > Change-Id: Id8f9f0abc5b564375c1b6d5d30c92d57d76520b7
> > Signed-off-by: Bryan Freed <bfreed@chromium.org>
> > ---
> >  Documentation/ramoops.txt |   19 +++++++++++++++++--
> >  fs/pstore/ram.c           |   43
> > +++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 60 insertions(+), 2 deletions(-)
>
> Can you document the binding in Documentation/devicetree/bindings/* too?

Good point, Stephen.  Will do...

>
> > diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> > index 9123cce..bf0f882 100644
> > --- a/fs/pstore/ram.c
> > +++ b/fs/pstore/ram.c
> > @@ -213,6 +248,14 @@ static int __init ramoops_probe(struct
> > platform_device *pdev)
> >       if (cxt->max_count)
> >               goto fail_out;
> >
> > +     if (pdev->dev.of_node) {
> > +             if (of_ramoops_platform_data(pdev->dev.of_node,
> > &of_pdata)) {
> > +                     pr_err("Invalid ramoops device tree data\n");
>
> dev_err()?

I feel dev_err() would be a step in the wrong direction, but I do not
really know the merits of one vs the other.
In looking through all of fs/*, I do not see any
dev_{err|warn|crit|alert|emerg|notice}() calls other than the two
dev_err() calls added to this file (fs/pstore/ram.c) just a few weeks
ago.
I feel more comfortable sticking with this file's "pr_err" convention.
 If that is incorrect, another change should be submitted to change
them all to dev_err().  In this respect, I think Anton's change of May
17 (896fc1f0 in my repo) should have followed the pr_err convention.

Anyone have a strong feeling on dev_err vs pr_err and how/if this
transition should occur?

bryan.

> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
