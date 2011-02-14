Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1BNGNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 01:13:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1BNGNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 01:13:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nM3lO/9RJ/PV4w4EAzwqf8qWur70DRY1Rpk7c6RIthaIIAFAt0MI0CL4yJ4f/Cm5Bz
         lyHT+XybYNyjKylcZZDw==
MIME-Version: 1.0
In-Reply-To: <20110209151046.89e03dcd.akpm@linux-foundation.org>
References: <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu>
 <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu> <20110209151046.89e03dcd.akpm@linux-foundation.org>
From: Paul Menage <menage@google.com>
Date: Sun, 13 Feb 2011 22:12:51 -0800
Message-ID: <AANLkTim7t8zBUcuVbmPQYuqjB1ZDQtrrpLtVRqT=PgDy@mail.gmail.com>
Subject: Re: [PATCH v8 0/3] cgroups: implement moving a threadgroup's threads
 atomically with cgroup.procs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 3:10 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 7 Feb 2011 20:35:42 -0500
> Ben Blum <bblum@andrew.cmu.edu> wrote:
>
>> On Sun, Dec 26, 2010 at 07:09:19AM -0500, Ben Blum wrote:
>> > On Fri, Dec 24, 2010 at 03:22:26AM -0500, Ben Blum wrote:
>> > > On Wed, Aug 11, 2010 at 01:46:04AM -0400, Ben Blum wrote:
>> > > > On Fri, Jul 30, 2010 at 07:56:49PM -0400, Ben Blum wrote:
>> > > > > This patch series is a revision of http://lkml.org/lkml/2010/6/25/11 .
>> > > > >
>> > > > > This patch series implements a write function for the 'cgroup.procs'
>> > > > > per-cgroup file, which enables atomic movement of multithreaded
>> > > > > applications between cgroups. Writing the thread-ID of any thread in a
>> > > > > threadgroup to a cgroup's procs file causes all threads in the group to
>> > > > > be moved to that cgroup safely with respect to threads forking/exiting.
>> > > > > (Possible usage scenario: If running a multithreaded build system that
>> > > > > sucks up system resources, this lets you restrict it all at once into a
>> > > > > new cgroup to keep it under control.)
>> > > > >
>
> The above six month old text is the best (and almost the only)
> explanation of the rationale for the entire patch series.  Is
> it still correct and complete?
>

It's still correct, but I'm sure we could come up with a more detailed
justification if necessary.

Paul
