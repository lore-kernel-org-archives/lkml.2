Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1KAOWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:22:10 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:34136 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966Ab1KAOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:22:09 -0400
X-Greylist: delayed 1281 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 10:22:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=IHaXB0sp3eWCICVBiSlGSX0mPGVaRXK3cC6NCZv6BuPvgCMIqQOMnwodM85/PfZG;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4EAFFB8E.20605@earthlink.net>
Date: Tue, 01 Nov 2011 10:00:46 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Vincent Pelletier <plr.vincent@gmail.com>, linux-kernel@vger.kernel.org
Subject: =?windows-1252?Q?Re=3A_ext4_bug_=3F_=22Intel_320_SSD?=
 =?windows-1252?Q?_write_performance_=96_contd=2E=22?=
References: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com> <20111031210951.GK16825@thunk.org> <4EAFF54C.7010406@earthlink.net> <C838F22F-D7B1-4911-B6F6-214240A77859@mit.edu>
In-Reply-To: <C838F22F-D7B1-4911-B6F6-214240A77859@mit.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7986788bb61a7412da1c3e1079a445054c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 09:41 AM, Theodore Tso wrote:
> On Nov 1, 2011, at 9:34 AM, Stephen Clark wrote:
>
>    
>>> You can enable the trim behaviour by default by adding to your
>>> /etc/mke2fs.conf file:
>>>
>>> [defaults]
>>> 	discard = true
>>>
>>> But then it's on your head if anything bad happens.  :-/
>>>
>>>          	      	      	      - Ted
>>>
>>>
>>>        
>> <snip>
>>
>> What about using discard in fstab like:
>> LABEL=/ /                      ext4    defaults,discard,noatime,nodiratime        1 1
>>      
> That does something different; this does continuous discards as you delete files.   This is probably the best thing to do if you are using thin-provisioning.   However, with SATA devices, a discard requires a queue flush, which can be a performance disaster.   (Also some cheaper SSD's also have real performance difficulties if there are frequent trims.)   There have also been reports that high frequency discards can trigger bugs that cause crappier SSD's to turn themselves into bricks.   The performance problems and the possibility of bricking crappier SSD's is why this isn't turned on by default.
>
> Because of this, another method is to do FITRIM's periodically using cron.   This has less of a performance impact, so it's probably the better approach in many cases.
>
> Basically, with SSD's and thin-provisioning systems, we are very much at the mercy at the competence of firmware authors.   As we know, sometimes firmware authors can be quite competent, or very, extremely incompetent.   So there will be a wide range of outcomes, which is one of the reasons why the best answer is to test to see what works best for you, preferably before you put use your systems in production.
>
> -- Ted
>    
So what I hear if that if you are using sata interface and not doing 
virtualization we should be using FITRIMS's from  a cron job. At what 
frequency should
we be doing this?

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



