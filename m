Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1F3WOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:14:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50957 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1F3WO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:14:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=NuEVzX6ZQGz3+fXzosunFroMyy9xjt+/mBf+9KyoHVUzbhvX22eaq8SiRBd6wId/R
	is5T89rgAPOSUb4WlizJQ==
MIME-Version: 1.0
In-Reply-To: <1309380221.26417.50.camel@gandalf.stny.rr.com>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	<m2tyb81jml.fsf@firstfloor.org>
	<CAPz4a6CbzEm3QJZ-5wsaiSH1H9g7tgo7E7-HyRB8Fv5=NfGDRQ@mail.gmail.com>
	<1309380221.26417.50.camel@gandalf.stny.rr.com>
Date: Thu, 30 Jun 2011 15:14:25 -0700
X-Google-Sender-Auth: MwviegNSMxNUquGmljVkdY6ryTQ
Message-ID: <CAPz4a6AHuBLfXPx4aXew0BCa3bQ-_kAnrpw_3f2r-5A9OhTTsg@mail.gmail.com>
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Dima Zavin <dima@android.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

So what would do you recommend I do? Is this patch acceptable or do
you want me to remove all the debug stuff and modify all the users to
not provide a lock?

--Dima

On Wed, Jun 29, 2011 at 1:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-06-29 at 13:34 -0700, Dima Zavin wrote:
>
>> The whole enforcement of locking inside this code is awkward anyway.
>> We don't enforce locking on rb_trees, or on list_head, etc. Why
>> plists? The funny part is that the test code in plist.c itself has a
>> hack to skip the lock check.
>
> It's a legacy from the -rt tree. With the development there, there was
> always a case where a plist was added without the proper locking, and we
> spent days debugging it. This test proved very useful. As plists came to
> mainline, we kept the tests.
>
> Now, getting rid of them maybe the thing to do. I'm not sure how useful
> they are today.
>
> -- Steve
>
>
>
