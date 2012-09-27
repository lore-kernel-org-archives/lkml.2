Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab2I0EKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:10:22 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44354 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2I0EKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:10:21 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-bf-5063d1ab4987
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        a.p.zijlstra@chello.nl, andi@firstfloor.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] perf hists browser: Add option for runtime switching perf data file
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-9-git-send-email-feng.tang@intel.com>
	<87d31ayhpy.fsf@sejong.aot.lge.com> <20120925162053.51f60773@feng-i7>
	<20120925111703.GC28902@infradead.org> <20120926075707.GA4919@feng-i7>
Date: Thu, 27 Sep 2012 13:02:05 +0900
In-Reply-To: <20120926075707.GA4919@feng-i7> (Feng Tang's message of "Wed, 26
	Sep 2012 15:57:07 +0800")
Message-ID: <874nmkw1tu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On Wed, 26 Sep 2012 15:57:07 +0800, Feng Tang wrote:
> On Tue, Sep 25, 2012 at 08:17:03AM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Sep 25, 2012 at 04:20:53PM +0800, Feng Tang escreveu:
>> > On Tue, 25 Sep 2012 11:11:21 +0900
>> > Namhyung Kim <namhyung@kernel.org> wrote:
>> > > Ditto.  Plus it might leak previous input_name.
>> > 
>> > Nice catch, will check the return value of "strdup". 
>> > 
>> > For input_name mem leak, in some cases the input_name can't be called
>> >  with free(), like those got from parse "-i" option. In case the old
>> > input_name is got from malloc through strdup, I think it's not a big
>> > issue given that buffer will be freed any way when the application exit.
>> 
>> I think this is a matter of discipline, leaking is bad, kernel or
>> userspace, why special case it?
>>
>
> I see, then we need make sure all "input_name" point to a malloced buffer, 
> here is a initial debug patch will only touch the annotate/report/script
> cmds, pls review and more suggestions are welcomed:

Well, how about adding a flag like "input_name_alloced" and checking it
before new allocation?  This way we can avoid needless strdup when
runtime switching is not used.

Thanks,
Namhyung
