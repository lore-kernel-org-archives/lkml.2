Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0JROUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:20:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab0JROUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:20:01 -0400
Message-ID: <4CBC5786.9000107@redhat.com>
Date: Mon, 18 Oct 2010 16:19:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>	<4CBAE8E2.1060704@redhat.com>	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>	<4CBBF3C8.9070104@web.de>	<4CBC1047.6010501@redhat.com>	<20101018125803.GA2497@darkstar>	<4CBC4B06.3030300@redhat.com>	<20101018134508.GA11885@darkstar>	<4CBC4FA9.90406@redhat.com>	<4CBC5097.1020105@redhat.com>	<20101018135813.GA20316@darkstar>	<4CBC547A.8080700@redhat.com>	<AANLkTi=htiXrjAnQcm7=Rha+PYQA7iibn3WFRzyx_Owq@mail.gmail.com>	<4CBC55FB.30205@redhat.com> <AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>
In-Reply-To: <AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/18/2010 04:15 PM, Dave Young wrote:
> On Mon, Oct 18, 2010 at 10:13 PM, Avi Kivity<avi@redhat.com>  wrote:
> >    On 10/18/2010 04:11 PM, Dave Young wrote:
> >>
> >>  On Mon, Oct 18, 2010 at 10:06 PM, Avi Kivity<avi@redhat.com>    wrote:
> >>  >      On 10/18/2010 03:58 PM, Dave Young wrote:
> >>  >>
> >>  >>    >
> >>  >>    >      Please patch hardware_setup() to show the value of
> >>  >>    >      boot_cpu_has(X86_FEATURE_NX).
> >>  >>
> >>  >>    It's 0
> >>
> >>  Please wait, I reply too quick, actually it boots two times fine then
> >>  one time fail.
> >
> >  What boots fine?  The guest?
>
> Yes the guest
>

That makes some sort of wierd sense.  First kvm samples X86_FEATURE_NX, 
sees that it has the feature, reports it to qemu, qemu runs the guest, 
NX gets disabled in between, the guest tries to enable NX, kvm kills it.

Second time round, kvm reports that NX is not available, qemu does not 
enable it, neither does the guest, and everyone is happy.

Please confirm that when the guest does boot, it boots without NX in 
/proc/cpuinfo.

-- 
error compiling committee.c: too many arguments to function

