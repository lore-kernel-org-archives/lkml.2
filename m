Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2GBXNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 19:13:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35688 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2GBXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 19:13:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120702215722.GC14479@tassilo.jf.intel.com>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
	<1341254598-1379-3-git-send-email-andi@firstfloor.org>
	<1341256733.23484.11.camel@twins>
	<20120702195744.GG11413@one.firstfloor.org>
	<1341260540.23484.25.camel@twins>
	<20120702210008.GB14479@tassilo.jf.intel.com>
	<1341265014.23484.47.camel@twins>
	<20120702215722.GC14479@tassilo.jf.intel.com>
Date: Tue, 3 Jul 2012 01:13:22 +0200
Message-ID: <CABPqkBSdtV6FTqVestcmy_skyK5AFTeShoT6vDFk34A0XaXWDA@mail.gmail.com>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 11:57 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Mon, Jul 02, 2012 at 11:36:54PM +0200, Peter Zijlstra wrote:
>> On Mon, 2012-07-02 at 14:00 -0700, Andi Kleen wrote:
>> > Ok so you want a new flag? Or a new event?
>>
>> Once we grow the sysfs event stuff for cpu PMUs, we could add a new
>> named event, but I don't think its all that important.
>>
>> instructions isn't all that interesting a measure to sample. And the
>> people that do care can already use it by filling out the event
>> manually.
>
> The idea was to make it easier to use, similar to the recent
> automatic IBS setup on AMD.
>
> It's the nearest you can get on Intel systems.
>
> I agree it would be nicer on cycles, but instructions are in many
> cases a reasonable approximation.
>
> BTW the problem with specifying it manually is that there
> is no way to enforce the SandyBridge quiescence restrictions.

Well, the only way I can think of would be to request that the
event be programmed with exclusive mode ALWAYS. That
should not be to hard to add.

> It would probably need forking the tables too and removing it on
> SandyBridge, or something special to enforce exclusive mode,
> all complicated and ugly.
>
> An explicit way to specify it side steps that all nicely.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
