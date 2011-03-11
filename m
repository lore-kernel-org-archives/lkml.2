Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1CKSCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:02:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49012 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1CKSCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d5Q+VKuti6owu2+g8zXgD+zhbpG2/ihLBxaurO5hJsfY2vqbx7widNyWh6cLDiWO/S
         lcoUoGBQn+SsKw6/QbXohvafJhl72Cvxw/A+ijLzxZWhCVTsvZ2THhjwfsbvV8AuHQMn
         f7JVgXM7PS3OKXy0VWUmGORvQJR5r2nSPiPMU=
MIME-Version: 1.0
In-Reply-To: <20110311155446.GH13038@htj.dyndns.org>
References: <4D6E9541.2040201@kernel.org>
	<20110302191338.GE28266@mtj.dyndns.org>
	<4D6EA975.8070200@kernel.org>
	<20110302205704.GF28266@mtj.dyndns.org>
	<4D6EB335.8000306@kernel.org>
	<20110303061711.GG28266@mtj.dyndns.org>
	<4D791C9F.1010500@kernel.org>
	<20110311082938.GC13038@htj.dyndns.org>
	<20110311083351.GD13038@htj.dyndns.org>
	<4D7A4430.1030301@kernel.org>
	<20110311155446.GH13038@htj.dyndns.org>
Date: Fri, 11 Mar 2011 10:02:41 -0800
X-Google-Sender-Auth: m32RN845wyPT_bRmQ3plLIF21R0
Message-ID: <AANLkTim31ZDBRtBFL2J5HD8j8__tzkSF_HdD-HVt6V49@mail.gmail.com>
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 7:54 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Mar 11, 2011 at 07:48:00AM -0800, Yinghai Lu wrote:
>> On 03/11/2011 12:33 AM, Tejun Heo wrote:
>> > On Fri, Mar 11, 2011 at 09:29:38AM +0100, Tejun Heo wrote:
>> >> Also, I don't think your patch is correct.  Even if there is phys_dist
>> >                                                               ^
>> >                                                           no
>> >> table, emu distance tables should be built because emulated nids don't
>> >> map to physical nids one to one.  ie. Two different emulated nids can
>> >> share a physical node and the distance table should explicitly reflect
>> >> that.
>>
>> ok, when original SLIT is not there, mean only one really node.
>> so the new distance table should be filled with LOCAL_DISTANCE.
>
> No, NUMA implementation can skip numa_set_distance() entirely if the
> distance is LOCAL_DISTANCE if nids are equal, REMOTE_DISTANCE
> otherwise.  In fact, any amdtopology configuraiton would behave this
> way, so it's incorrect to fill the table with LOCAL_DISTANCE.  You
> have to check the physnid mapping and build new table whether physical
> table exists or not.  Lack of physical distance table doesn't mean all
> nodes are LOCAL_DISTANCE.

too bad. We should call numa_alloc_distance in amdtopology to set
default value in that array.

Yinghai
