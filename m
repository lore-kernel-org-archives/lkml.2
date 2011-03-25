Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1CYOuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:50:40 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63182 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1CYOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vA92q1sYVSrn2jVUryNaxuDCs38YwGQB8T7UIc+GbiSnANQo2x5Mm/NbJ/8xkb3VCU
         pC2KvlJlXbYQ7yiU9U+tJgRAJHIG32yx+/8DAnE+/qdAjSYbtey/4g7zMbvVGimjppid
         AqFbWjoqpsVWgHXJfkpPYaG2LzKLQD1TA4bzQ=
MIME-Version: 1.0
In-Reply-To: <1301049130.2250.185.camel@laptop>
References: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
	<1301049130.2250.185.camel@laptop>
Date: Fri, 25 Mar 2011 15:50:37 +0100
Message-ID: <AANLkTinB2EAh=mpqh-y4=5xKPdyJWwUWFVMk=WAx1QBp@mail.gmail.com>
Subject: Re: [PATCH] perf: Better fit max unprivileged mlock pages for tools needs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Stable <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/25 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2011-03-23 at 19:29 +0100, Frederic Weisbecker wrote:
>
>> -int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
>> +/* Minimum for 128 pages + 1 for the user control page */
>> +int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
>
> This assumes PAGE_SIZE = 4k..

Yeah, should I rebase the value on top of PAGE_SIZE?
