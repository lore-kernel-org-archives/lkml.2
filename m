Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1CKSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:25:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36599 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1CKSZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:25:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w6jkMrXMkGIO9lFHPE3/VCg5zFHcw5/s1W3PQIewHFjPHEEVXi8/VvUt3a/VVm+fHS
         9kRUQb1R7ruWxtCpqUgeT8TAip8dcT/PmEO0Qwp5+sETCz5QWv3HD4VlNydJGu7wKnnf
         ZkO2nVDEHL/C8WVhzkMmgmE6l7CrlWnp8PH60=
MIME-Version: 1.0
In-Reply-To: <20110311181958.GJ13038@htj.dyndns.org>
References: <4D6EA975.8070200@kernel.org>
	<20110302205704.GF28266@mtj.dyndns.org>
	<4D6EB335.8000306@kernel.org>
	<20110303061711.GG28266@mtj.dyndns.org>
	<4D791C9F.1010500@kernel.org>
	<20110311082938.GC13038@htj.dyndns.org>
	<20110311083351.GD13038@htj.dyndns.org>
	<4D7A4430.1030301@kernel.org>
	<20110311155446.GH13038@htj.dyndns.org>
	<AANLkTim31ZDBRtBFL2J5HD8j8__tzkSF_HdD-HVt6V49@mail.gmail.com>
	<20110311181958.GJ13038@htj.dyndns.org>
Date: Fri, 11 Mar 2011 10:25:23 -0800
X-Google-Sender-Auth: w1qWthb-1l-OdodAKMSqNOIqbO4
Message-ID: <AANLkTimAA-NF43DtrZTHZWLyYMVdDkw89QCLcfsC0Rbh@mail.gmail.com>
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

On Fri, Mar 11, 2011 at 10:19 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Mar 11, 2011 at 10:02:41AM -0800, Yinghai Lu wrote:
>> > No, NUMA implementation can skip numa_set_distance() entirely if the
>> > distance is LOCAL_DISTANCE if nids are equal, REMOTE_DISTANCE
>> > otherwise.  In fact, any amdtopology configuraiton would behave this
>> > way, so it's incorrect to fill the table with LOCAL_DISTANCE.  You
>> > have to check the physnid mapping and build new table whether physical
>> > table exists or not.  Lack of physical distance table doesn't mean all
>> > nodes are LOCAL_DISTANCE.
>>
>> too bad. We should call numa_alloc_distance in amdtopology to set
>> default value in that array.
>
> I'm not following.  If there's no distance table, the distance is
> assumed to be LOCAL between the same node and REMOTE if the nodes are
> different, which is exactly the way it should be for those machines.
> Why is this bad and why would you allocate distance table for such
> configurations?

now even emulation have that distance array.

why keep it simple to make all path have that array?

Yinghai
