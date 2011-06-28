Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab1F1OZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:25:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab1F1OYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:24:08 -0400
Subject: Re: [PATCH v2] futex: Fix regression with read only mappings
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4E09E300.2060800@linux.intel.com>
References: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>
	 <1308931186-28707-1-git-send-email-sbohrer@rgmadvisors.com>
	 <4E052DC3.6000902@linux.intel.com>
	 <20110627164008.GA2095@BohrerMBP.rgmadvisors.com>
	 <1309198559.6701.108.camel@twins> <4E08EAE8.6060805@linux.intel.com>
	 <20110627210818.GC2095@BohrerMBP.rgmadvisors.com>
	 <4E08F893.10103@linux.intel.com> <1309258236.6701.199.camel@twins>
	 <4E09E300.2060800@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 16:23:03 +0200
Message-ID: <1309270983.6701.212.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 07:19 -0700, Darren Hart wrote:
> 
> On 06/28/2011 03:50 AM, Peter Zijlstra wrote:
> > On Mon, 2011-06-27 at 14:39 -0700, Darren Hart wrote:
> >> The alternative it seems is to just let RW private users hang
> >> themselves.
> > 
> > Yeah, screw those, that's insane anyway.
> 
> And I meant RO private users (for those reading just this message and
> getting really confused ;-)

RW private is crazy too, there is no guarantee you'll stay shared and
thus relying on the shared part of the semantics is broken. As is
clearly documented in the mmap() man page as pointed out by someone
somewhere in this thread.
