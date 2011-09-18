Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1IRGg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 02:36:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42793 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1IRGg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 02:36:58 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20110915161430.GE1548@tusker>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
	<20110902002917.GD2752@htj.dyndns.org>
	<20110915161430.GE1548@tusker>
Date: Sun, 18 Sep 2011 09:36:57 +0300
Message-ID: <CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Sep 15, 2011 at 7:14 PM, Ripduman Sohan
<Ripduman.Sohan@cl.cam.ac.uk> wrote:
> Tejun Heo <tj@kernel.org> wrote:
>
>> Hello,
>>
>> On Thu, Sep 01, 2011 at 02:36:33PM +0100, Ripduman Sohan wrote:
>> > Rescuer threads may be migrated (and are bound) to particular CPUs when
>> > active.  However, the allowed_cpus mask is not restored when they return
>> > to sleep rendering inconsistent the presented and actual set of CPUs the
>> > process may potentially run on.  This patch fixes this oversight by
>> > recording the allowed_cpus mask for rescuer threads when it enters the
>> > rescuer_thread() main loop and restoring it every time the thread sleeps.
>>
>> Hmmm... so, currently, rescuer is left bound to the last cpu it worked
>> on.  Why is this a problem?
>

There is at least one use case where I think this can be a problem -
cpu isolation.

If you decide to partition your CPU to give some group of processes a
set of CPUs all to their own (using cgroups/cpuset for example) having
non related bound processes really gets in the way. You would really
want to migrate away non related tasks from the isolated cpuset and
having a bound kernel thread prevents that.

Gilad
-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com
"Dance like no one is watching, love like you'll never be hurt, sing
like no one is listening... but for BEEP sake you better code like
you're going to maintain it for years!"
