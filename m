Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1GGVbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:31:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20205 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1GGVbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:31:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=UmVOFghNp1T/mnDZte/d4rC0lk/tlWrAjxuHoM5zt2VVB8iSDM5RhwZZ55Ub3HUMq
	8IuiMx6OJiph3k5hD+rUA==
MIME-Version: 1.0
In-Reply-To: <1310046524.3282.570.camel@twins>
References: <20110707053036.173186930@google.com> <20110707053059.981950189@google.com>
 <1310046524.3282.570.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 7 Jul 2011 14:30:31 -0700
Message-ID: <CAPM31RJwU-QH0qUiRnT7k0JA5s5D6e=Zqe+W_tq-MBtjww-gxA@mail.gmail.com>
Subject: Re: [patch 03/17] sched: introduce primitives to account for CFS
 bandwidth tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 6:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2011-07-06 at 22:30 -0700, Paul Turner wrote:
>> +config CFS_BANDWIDTH
>> +       bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
>> +       depends on EXPERIMENTAL
>> +       depends on FAIR_GROUP_SCHED
>> +       depends on SMP
>
> I know that UP is quickly becoming extinct, but isn't that a tad
> radical? :-)
>

Right, this was because walk_tg_tree (and some friends) were not
available in the FAIR_GROUP && !SMP case.  The wreckage used to be a
little more extensive but I just tried it again the last rounds of
clean-up seem to have fixed most of it, the only other problem was
updating the SMP group load stuff in the unthrottle path.

I've rolled the required #ifdef-erry to fix the above up and it's not
horrifying so... dependency removed!
