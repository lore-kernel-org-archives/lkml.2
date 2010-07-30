Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab0G3EKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:10:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0G3EKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:10:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=N5PaEREIEdNZqD4GZdELshvVlGUxFtJ4K4sOdN5TFuzGKeMtLcR1lrSWZP8/TAJOE
	xWonCJW9fW7xk47RitCyA==
MIME-Version: 1.0
In-Reply-To: <20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 29 Jul 2010 21:10:10 -0700
Message-ID: <AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Hugh Dickins <hughd@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 5:01 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I think the best way is kexec(). But maybe rollback from hibernation failure
> will be difficult. Considering how crash-dump works well and under maintainance
> by many enterprise guys, hibernation-by-kexec is a choice. I think. It can make
> reuse of kdump code, ...or, hibernation-resume code can eat kdump image
> directly. Maybe the problem will be the speed of dump.

I've no appetite for a total rework of hibernation, and I don't see
how that would
address the issue: I'm just looking for some protection against swap
reuse danger.

Hugh
