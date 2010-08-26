Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0HZCIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:08:55 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0HZCIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sye6mJQTMMABuwWFgJ/WTuXNsqeuhGEx9hoZxQ0n3c5EyOZFTR0pJQ11Yk01K6CcCk
         xedab+yHRjocOIJ4AElQ==
MIME-Version: 1.0
In-Reply-To: <20100825143520.9954d3f9.akpm@linux-foundation.org>
References: <20100805225914.GA26772@redhat.com>
	<4C5C3985.5060706@us.ibm.com>
	<1281112704.10055.0.camel@x201>
	<20100825143520.9954d3f9.akpm@linux-foundation.org>
Date: Wed, 25 Aug 2010 19:08:46 -0700
Message-ID: <AANLkTimyUhwRA03=Ee3a3PPQrKuzVYRzhc52K=mV02PR@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix API thinko
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ben Blum <bblum@google.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 2:35 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> So am I correct to assume that this change is now needed in 2.6.36, and
> unneeded in 2.6.35?
>
> Can it affect the userspace<->kernel API in amy manner?  If so, it
> should be backported into earlier kernels to reduce the number of
> incompatible kernels out there.

AFAICS it shouldn't affect any existing APIs, either in-kernel or to
userspace - it just makes the existing function
cgroup_attach_task_current_cg() a specialization of a more generic new
function.

>
> Paul, did you have any comments?

Other than the language being a bit confusing, it seems fine. I'd
probably word the patch description as:

Add cgroup_attach_task_all()

The existing cgroup_attach_task_current_cg() API is called by a thread
to attach another thread to all of its cgroups; this is unsuitable for
cases where a privileged task wants to attach itself to the cgroups
of a less privileged one, since the call must be made from the context
of the target task.

This patch adds a more generic cgroup_attach_task_all() API that
allows both the source task and to-be-moved task to be specified.
cgroup_attach_task_current_cg() becomes a specialization of the more
generic new function.

Acked-by: Paul Menage <menage@google.com>
