Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3AEEPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 23:15:43 -0500
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:59252 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002Ab3AEEPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 23:15:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=T4bMgRIiL9JN6XRL5SCQUozkR0bUmQLYDkni8TKNGuGcx15TFVEeQyghQmtZ/ywU;
  h=Message-ID:Date:From:Reply-To:To:Subject:Cc:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <18814090.1357359340232.JavaMail.root@mswamui-bichon.atl.sa.earthlink.net>
Date: Fri, 4 Jan 2013 23:15:39 -0500 (GMT-05:00)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: no config opt for k8temp in 3.6.11
Cc: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb0630c2ba6cdcad306d82c3b4fdfb511ce9ba93f03882d750350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I do a grep for K8 in my .config file all I get is the following:

> grep -i k8 /usr/local/hugedisk/src/linux-3.6.11/.config
CONFIG_MK8=y
CONFIG_X86_POWERNOW_K8=y

When I try your grep command I get:

> grep -E "^CONFIG_SENSORS" /usr/local/hugedisk/src/linux-3.6.11/.config|grep K
CONFIG_SENSORS_K10TEMP=m

I will try doing a make mrproper and see if anything changes.

Thanks for the reply.
--
Steven DuChene


-----Original Message-----
>From: Borislav Petkov <bp@alien8.de>
>Sent: Jan 4, 2013 3:35 PM
>To: "Steven A. DuChene" <linux-clusters@mindspring.com>
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: no config opt for k8temp in 3.6.11
>
>On Fri, Jan 04, 2013 at 09:25:14AM -0500, Steven A. DuChene wrote:
>> I have a few systems with AMD processors. One is a AMD Phenom II based
>> system which uses a k10temp kernel module to get the CPU temperature.
>> Another system has an Athlon64 processor which apparently is supposed
>> to use a k8temp module to do the same thing. I have built a 3.6.11
>> kernel for each system that otherwise runs OpenSuSE-11.X. On the
>> Phenom system the k10temp module is gets built and performs as
>> expected. However on the Atlnon system even though I see the k8temp.c
>> source file in the drivers/hwmon directory there does not seem to be
>> a way in the kernel config files available from the 3.6.11 kernel
>> sources to actually select that the k8temp module should be built. Is
>> this some oversight in the makeup of the kernel config files or am I
>> missing something obvious?
>
>That's strange, I can select all the AMD power drivers on 3.6.11:
>
>$ grep -E "^CONFIG_SENSORS" .config
>CONFIG_SENSORS_K8TEMP=m
>CONFIG_SENSORS_K10TEMP=m
>CONFIG_SENSORS_FAM15H_POWER=m
>
>Can you do 'make mrproper' and try regenerating your config? But
>remember, mrproper will remove your .config so you might want to save
>that upfront in case you need it.
>
>HTH.
>
>-- 
>Regards/Gruss,
>Boris.



