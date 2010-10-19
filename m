Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0JSPFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:05:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0JSPFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:05:01 -0400
Message-ID: <4CBDB38E.7090801@redhat.com>
Date: Tue, 19 Oct 2010 17:04:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Young <hidave.darkstar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com> <4CBAE8E2.1060704@redhat.com> <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com> <4CBBF3C8.9070104@web.de> <4CBC1047.6010501@redhat.com> <20101018125803.GA2497@darkstar> <4CBC4B06.3030300@redhat.com> <20101018134508.GA11885@darkstar> <4CBC4FA9.90406@redhat.com> <4CBC5097.1020105@redhat.com> <20101018135813.GA20316@darkstar> <4CBC547A.8080700@redhat.com> <4CBC964B.6000605@zytor.com> <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com> <4CBD099D.2060500@zytor.com> <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com> <4CBD5D8F.6020505@redhat.com> <a4d1e098-7b9b-43f8-b341-2e0dbf1db780@email.android.com>
In-Reply-To: <a4d1e098-7b9b-43f8-b341-2e0dbf1db780@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/19/2010 04:56 PM, H. Peter Anvin wrote:
> Right... note in particular that the BIOS sets them up inconsistently.  The kernel is doing the rufht thing: since NX isn't available on all processors it is considered unavailable.

I guess kvm should be modified to mask GET_SUPPORTED_CPUID results with 
the boot_cpu features.  This will make kvm take advantage of the core 
kernel doing the right thing.

