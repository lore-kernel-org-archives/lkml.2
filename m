Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0ETWWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:22:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51488 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0ETWWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:22:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=n3xJDK+0Rcbq39qNQyRFcL2bvr+nIcNg3jHMTdsCyxXXi9Nnf4+0L9/LYSrYpDM66
	xUy0aXTf5b6S2LJO1rGrQ==
MIME-Version: 1.0
In-Reply-To: <1274227488.2370.107.camel@w-sridhar.beaverton.ibm.com>
References: <1274227488.2370.107.camel@w-sridhar.beaverton.ibm.com>
Date: Thu, 20 May 2010 15:22:15 -0700
Message-ID: <AANLkTinsrFoLVKDFM5pcKcL_6MvAzhR6IzbNmWKh3BDh@mail.gmail.com>
Subject: Re: [PATCH 1/3] cgroups: Add an API to attach a task to current 
	task's cgroup
From: Paul Menage <menage@google.com>
To: Sridhar Samudrala <samudrala.sridhar@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 5:04 PM, Sridhar Samudrala
<samudrala.sridhar@gmail.com> wrote:
> Add a new kernel API to attach a task to current task's cgroup
> in all the active hierarchies.
>
> Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>

Reviewed-by: Paul Menage <menage@google.com>

It would be more efficient to just attach directly to current->cgroups
rather than potentially creating/destroying one css_set for each
hierarchy until we've completely converged on current->cgroups - but
that would require a bunch of refactoring of the guts of
cgroup_attach_task() to ensure that the right can_attach()/attach()
callbacks are made. That doesn't really seem worthwhile right now for
the initial use, that I imagine isn't going to be
performance-sensitive.

Paul
