Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1GGR3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:29:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab1GGR3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:29:10 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <20110707162344.GB2536@redhat.com>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
	 <20110707145159.GD19193@elte.hu> <1310050482.3282.584.camel@twins>
	 <20110707145620.GF19193@elte.hu>  <20110707162344.GB2536@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 19:20:20 +0200
Message-ID: <1310059220.3282.591.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 12:23 -0400, Jason Baron wrote:

> yes, this is the type of case jump labels is designed for. Let me know
> if there are any usage questions/concerns.

Unrelated to this change, I was looking at a case where it would be nice
to have a way to specify the initial state of jump labels.

That is, currently:

jump_label_key foo;

  if (static_branch(&foo))

will default to false, until jump_label_inc(&foo) etc..

I was looking to add something like:

jump_label_key foo = JUMP_LABEL_TRUE;

Which would initialize the thing to be true, the problem with that is
that it takes until the loop in jump_label_init() before that takes
effect, which was too late in my particular case.

Anyway, not the current problem and probably not your problem anyway,
but I wanted to throw the issue out there.
