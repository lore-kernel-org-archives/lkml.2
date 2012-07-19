Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2GSWO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:14:28 -0400
Received: from nm31-vm2.bullet.mail.bf1.yahoo.com ([72.30.239.10]:38703 "HELO
	nm31-vm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751971Ab2GSWOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:14:25 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 18:14:25 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 327304.90017.bm@omp1015.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=gXL5CKKfNi2jooDCRgfdcz9gLQX20uEb2TwwJjLZznpmmVBdfhyJ758GUcvebwtS9GHYbK2uc784yWCIU2JHOR0bQzd1fKvxFfCUOhp/cdf172md+D2y+tZ9NPK5Do9mgClmCiA5/IH/znjb0qTdRxxh0u8Qat2JqzBN0X4cyaE=;
X-YMail-OSG: 9MlUgqAVM1mIcG_9s6ZfHNNNHfY1OhwFqb1IorMAkqsyi0o
 hDqHo7zq547R0Fb7xrCvk2DK.YX_G8we6K57St0V9eHcjnmKHnU0Kdatl8AF
 CIRF1XC.Duo5MZFRCvlx5DzXEAfh5pg58hFgd9atQt6KF94jg2sE4RAnN7C3
 edYOL1EQu6bC9GsXTdHYjvtHikjs5lEQx5IFV2VfpuEqUuRytU7tvDUXM7GE
 LgoMCWsIkSjHGXyMOQjOxegTctWbH1sSujbWszUO.fGtBIMUwiN.vgcpRWQF
 d5R_.V.HQxzI3PDnDH.CYjzx5KCnWozXAEFldwmta3SUJ3XxU3jTFO.nEPQ9
 adzoqk49CGR_yWBXFOyKzmBSzsrsXhI1cqULNlksNmlDeItiuu6AYQEbtAch
 tJPpEPa6c3ImQfDNzeUHoeuJzagKTTsuXLO6RwhGy_iP1yB_FNmALvrGTFrG
 lzz7XaTZlVRLF5bbgKJjWvZamuTYGTnw-
X-Mailer: YahooMailWebService/0.8.120.356233
Message-ID: <1342735724.60460.YahooMailNeo@web160604.mail.bf1.yahoo.com>
Date: Thu, 19 Jul 2012 15:08:44 -0700 (PDT)
From: joe shmoe <joeshmoeypeter@yahoo.com>
Reply-To: joe shmoe <joeshmoeypeter@yahoo.com>
Subject: kdump/kexec vmcore size doubles each time
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am trying to configure kexec/kdump on 2.6.35-14. 


$> kexec --version
kexec-tools-testing 20080330 released 30th March 2007


I did manage to configure kdump to use raw device (/dev/sda7) for saving the dump from within the initrd.

When the production kernel boots, it copies core from /dev/sda7 to /var/crash/ path.
I see that the size of data copied over from /dev/sda7 to /var/crash almost doubles with every crash (370MB to 620MB to 1.2 GB to 2.1GB). 


The size returns back to normal, should there be a "normal" reboot cycle anytime. After that every subsequent crash again doubles the size. This is very baffling. 

On a related note, I wanted to understand if there are any known issues with having swap device as a dump location. Does kdump start 
early enough to ensure that vmcore can be safely copied off swap 
/dev/sda7 and THEN mkswap/swapon commands set up the swap space?


Thanks much.
