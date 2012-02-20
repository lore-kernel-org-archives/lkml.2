Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2BTNIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 08:08:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2BTNIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 08:08:37 -0500
Message-ID: <1329743311.2293.341.camel@twins>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 20 Feb 2012 14:08:31 +0100
In-Reply-To: <4F3F025B.5010400@linux.vnet.ibm.com>
References: <4F2F9F6C.1090608@linux.vnet.ibm.com>
	 <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com>
	 <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com>
	 <1329402561.2293.225.camel@twins> <4F3DEDC3.4010004@linux.vnet.ibm.com>
	 <4F3F025B.5010400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 09:43 +0800, Michael Wang wrote:
> And as reight_entity is invoked very often, I think this patch can do some help to the 
> performance, although there are no numbers, we can prove it logically :)  

Well, you're probably right (although I think you completely ignored the
optimizing compiler), but still it would be good to get some numbers to
confirm reality :-)

Just pick your favourite cgroup workload/benchmark and run a pre/post
comparison, possible using perf record.

If all squares up you should see an improvement in your benchmark score
as well as see a reduction in time spend in the function you're
patching.
