Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0JROZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:25:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55733 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0JROZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rc7y2h45ds5dqMPYID2ivFPxZCKwRTPUYyLDPj6tDl1dn2kwvIZyDPv16Ofax7IrcT
         dmSqA8kRGMr1V3hEVNr6hsvrkMMtVaOGe5xFsPFi5RpC9c8jMxTnGTh41dpJVKW0/1hH
         OcUhsmQQVzqjdrBmwWDZ2Xv6t+p+n93T9wbRU=
MIME-Version: 1.0
In-Reply-To: <4CBC5786.9000107@redhat.com>
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
	<4CBAE8E2.1060704@redhat.com>
	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
	<4CBBF3C8.9070104@web.de>
	<4CBC1047.6010501@redhat.com>
	<20101018125803.GA2497@darkstar>
	<4CBC4B06.3030300@redhat.com>
	<20101018134508.GA11885@darkstar>
	<4CBC4FA9.90406@redhat.com>
	<4CBC5097.1020105@redhat.com>
	<20101018135813.GA20316@darkstar>
	<4CBC547A.8080700@redhat.com>
	<AANLkTi=htiXrjAnQcm7=Rha+PYQA7iibn3WFRzyx_Owq@mail.gmail.com>
	<4CBC55FB.30205@redhat.com>
	<AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>
	<4CBC5786.9000107@redhat.com>
Date: Mon, 18 Oct 2010 22:25:23 +0800
Message-ID: <AANLkTik9WK4+qSa=TdZR37cz2KTAvV+SH6iLmC=Em1Oa@mail.gmail.com>
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:19 PM, Avi Kivity <avi@redhat.com> wrote:
>  On 10/18/2010 04:15 PM, Dave Young wrote:
>>
>> On Mon, Oct 18, 2010 at 10:13 PM, Avi Kivity<avi@redhat.com>  wrote:
>> >    On 10/18/2010 04:11 PM, Dave Young wrote:
>> >>
>> >>  On Mon, Oct 18, 2010 at 10:06 PM, Avi Kivity<avi@redhat.com>    wrote:
>> >>  >      On 10/18/2010 03:58 PM, Dave Young wrote:
>> >>  >>
>> >>  >>    >
>> >>  >>    >      Please patch hardware_setup() to show the value of
>> >>  >>    >      boot_cpu_has(X86_FEATURE_NX).
>> >>  >>
>> >>  >>    It's 0
>> >>
>> >>  Please wait, I reply too quick, actually it boots two times fine then
>> >>  one time fail.
>> >
>> >  What boots fine?  The guest?
>>
>> Yes the guest
>>
>
> That makes some sort of wierd sense.  First kvm samples X86_FEATURE_NX, sees
> that it has the feature, reports it to qemu, qemu runs the guest, NX gets
> disabled in between, the guest tries to enable NX, kvm kills it.
>
> Second time round, kvm reports that NX is not available, qemu does not
> enable it, neither does the guest, and everyone is happy.
>
> Please confirm that when the guest does boot, it boots without NX in
> /proc/cpuinfo.
>

Yes, there's no nx in guest cpuinfo

hardware_setup is run only when insmod so the nx is of host,  thus the
first printk result is right value?
> --
> error compiling committee.c: too many arguments to function
>
>



-- 
Regards
dave
