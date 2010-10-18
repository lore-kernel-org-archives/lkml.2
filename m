Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0JRO2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0JRO2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:28:45 -0400
Message-ID: <4CBC5991.5090400@redhat.com>
Date: Mon, 18 Oct 2010 16:28:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>	<4CBAE8E2.1060704@redhat.com>	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>	<4CBBF3C8.9070104@web.de>	<4CBC1047.6010501@redhat.com>	<20101018125803.GA2497@darkstar>	<4CBC4B06.3030300@redhat.com>	<20101018134508.GA11885@darkstar>	<4CBC4FA9.90406@redhat.com>	<4CBC5097.1020105@redhat.com>	<20101018135813.GA20316@darkstar>	<4CBC547A.8080700@redhat.com>	<AANLkTi=htiXrjAnQcm7=Rha+PYQA7iibn3WFRzyx_Owq@mail.gmail.com>	<4CBC55FB.30205@redhat.com>	<AANLkTikKf1XnbWXm6TqSeQe_fUVjeSR0J8DTvcEy3xcP@mail.gmail.com>	<4CBC5786.9000107@redhat.com> <AANLkTik9WK4+qSa=TdZR37cz2KTAvV+SH6iLmC=Em1Oa@mail.gmail.com>
In-Reply-To: <AANLkTik9WK4+qSa=TdZR37cz2KTAvV+SH6iLmC=Em1Oa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/18/2010 04:25 PM, Dave Young wrote:
> >
> >  That makes some sort of wierd sense.  First kvm samples X86_FEATURE_NX, sees
> >  that it has the feature, reports it to qemu, qemu runs the guest, NX gets
> >  disabled in between, the guest tries to enable NX, kvm kills it.
> >
> >  Second time round, kvm reports that NX is not available, qemu does not
> >  enable it, neither does the guest, and everyone is happy.
> >
> >  Please confirm that when the guest does boot, it boots without NX in
> >  /proc/cpuinfo.
> >
>
> Yes, there's no nx in guest cpuinfo
>
> hardware_setup is run only when insmod so the nx is of host,  thus the
> first printk result is right value?

There's no right value since the two cpus have different values for nx.


-- 
error compiling committee.c: too many arguments to function

