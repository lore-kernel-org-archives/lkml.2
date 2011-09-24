Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1IXCjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 22:39:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1IXCjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 22:39:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kdnhdQF5MWZ2UaujzkTpW+QKA+FPovkCrt7pI1i7Q98SucZwycjDBEazQp4ut6cWr
	+YvGyJI3YSq1MLoJ1/VnQ==
MIME-Version: 1.0
In-Reply-To: <CAHH2K0Z_MsVceOjoFwT=qORSsKrFWjs_V602NMtPBysasJLEww@mail.gmail.com>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com> <CAHH2K0Z_MsVceOjoFwT=qORSsKrFWjs_V602NMtPBysasJLEww@mail.gmail.com>
From: Greg Thelen <gthelen@google.com>
Date: Fri, 23 Sep 2011 19:39:05 -0700
Message-ID: <CAHH2K0agLygD6cREazsTquCT=Whx97RxxhOneWpVF1cHwMwp3A@mail.gmail.com>
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        bsingharora@gmail.com, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: updated Balbir Singh email address

On Fri, Sep 23, 2011 at 7:34 PM, Greg Thelen <gthelen@google.com> wrote:
> On Fri, Sep 23, 2011 at 5:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> The code in memcg_check_events() calls this_cpu_read() on
>> different variables without disabling preemption, and can cause
>> the calculations to be done from two different CPU variables.
>>
>> Disable preemption throughout the check to keep apples and oranges
>> from becoming a mixed drink.
>>
>> [ Added this_cpu to __this_cpu conversion by Johannes ]
>>
>> Cc: Greg Thelen <gthelen@google.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>

Correction:
Cc: Balbir Singh <bsingharora@gmail.com>

>> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Christoph Lameter <cl@linux.com>
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> Link: http://lkml.kernel.org/r/20110919212641.015320989@goodmis.org
>
> Looks good to me.  Thanks.
>
> Reviewed-by: Greg Thelen <gthelen@google.com>
>
