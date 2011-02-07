Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1BGVeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:34:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab1BGVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:33:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mxKfe9tdqD8Wa2YOH9iS9qYWgmpwjf6SdF9P6kalfjcXO/IJoSCrxkf3ya0YHi0m6F
         2Vx8fZ3vMAR9nen4Sm3Q==
MIME-Version: 1.0
In-Reply-To: <1297109362.13327.56.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
 <20110202115012.GA16409@balbir.in.ibm.com> <1296650792.26581.319.camel@laptop>
 <AANLkTi=+W-BXHFG94MeOnqV82HxtqtyDwEt1RCOUMrcq@mail.gmail.com> <1297109362.13327.56.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Mon, 7 Feb 2011 13:33:34 -0800
Message-ID: <AANLkTinvN9zcG5tzVjyZTfLKofxz-utWzYXvv9Um9sK5@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 12:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Also, the core cgroup code should deal with the cgroup refcount, not
> individual controllers.

Right, that's what I meant - make it so that an rmdir that fails
because a subsystem is still holding a refcount puts/leaves the cgroup
in a state where userspace will still get a notification when the last
refcount is dropped. Not something that the subsystem would have to
worry about.

Paul
