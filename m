Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1JRIQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:16:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5762 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1JRIQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:16:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Pfr5+OV5hOwV8hKAjvNoeHKaHzKy8iFTL/Y7vgyAt4Tk8MPYiz1hJqiK9w0ezA3jh
	7vBUBS2IWJ+sCcCKpPJrw==
Date: Tue, 18 Oct 2011 01:16:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <efault@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
In-Reply-To: <1318925436.9641.23.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1110180115190.8959@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net>
 <1318925436.9641.23.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Mike Galbraith wrote:

> Ahem, the buildable copy..
> 
> I've been asked to add this toe saver to the trees I work on at least
> until something better comes along.  ACK/NACK equally understandable
> given the infrequency of the toe shooting, and user's right to do so.
> 
> Off you go, fly or die little patchlet.
> 

Heh.

> cpusets, cgroups: disallow attaching kthreadd
> 
> Allowing kthreadd to be moved to a non-root group makes no sense, it being
> a global resource, and needlessly leads unsuspecting users toward trouble.
> 
> 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> allocated is not schedulable.  Simple user error, but harmful to the box.
> 
> 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> rendering the cpuset immortal.
> 
> Save the user some unexpected trouble, just say no.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Acked-by: David Rientjes <rientjes@google.com>
