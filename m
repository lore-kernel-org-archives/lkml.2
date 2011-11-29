Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1K2Nvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:51:54 -0500
Received: from smtprelay0212.b.hostedemail.com ([64.98.42.212]:57686 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754760Ab1K2Nvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:51:52 -0500
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,4e80bef0b95bc1d2,d41d8cd98f00b204,t.artem@lycos.com,mhocko@suse.cz:pomac@vapor.com:linux-kernel@vger.kernel.org:rjw@sisk.pl:tino.keitel@tikei.de,RULES_HIT:152:355:379:541:582:599:601:945:973:988:989:1152:1260:1277:1311:1313:1314:1345:1358:1437:1515:1516:1518:1534:1541:1593:1594:1676:1711:1730:1747:1766:1792:2198:2199:2393:2553:2559:2562:3027:3138:3352:3622:3865:3867:3868:3869:3870:3871:3872:3873:3874:5007:6119:6261:7903:7974:10004:10016:10400:11473:11657:11658:11914:12043,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:1:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2365
Date: Tue, 29 Nov 2011 13:51:50 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: mhocko@suse.cz
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Message-ID: <64735828.563416.1322574710833.JavaMail.mail@webmail09>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111129123156.GA4043@tiehlicka.suse.cz>
 <20111129124406.GB4043@tiehlicka.suse.cz>
 <1833322904.224056.1322571256185.JavaMail.mail@webmail07>
 <20111129131042.GC4043@tiehlicka.suse.cz>
Subject: Re: Re: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU
 usage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.218.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2011, Michal Hocko wrote: 

> It seems that this is cannot be set in runtime:
> SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
> 
> Or maybe you need to boot with cpuidle_sysfs_switch. According to the
> documentation you might be able to change the governor. I have no idea
> whether this can help somehow but let's try that.
> 
> I haven't found any intel_idle machine in my lab so far and all other
> acpi_idle machines seem to work (or at least randomly selected ones) so
> this smells like a major difference in the setup.

# echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
bash: /sys/devices/system/cpu/cpuidle/current_driver: Permission denied

BTW

# cat  /sys/devices/system/cpu/cpuidle/available_governors
ladder menu

dmesg | grep -i idle
[    0.000000] Kernel command line: root=/dev/sda1 ro cpuidle_sysfs_switch
[    0.000126] using mwait in idle threads.
[    1.083872] intel_idle: MWAIT substates: 0x1120
[    1.083873] intel_idle: v0.4 model 0x2A
[    1.083874] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.159043] cpuidle: using governor ladder
[    1.168842] cpuidle: using governor menu
