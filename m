Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1KANeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:34:09 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:39375 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab1KANeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:34:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Pcj+rHm/AZglf+YpL2bndG8eI0QbbQ1qA9ZvHMYJK2neUh228WYBP+OqIgdZ8bZ0;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4EAFF54C.7010406@earthlink.net>
Date: Tue, 01 Nov 2011 09:34:04 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Vincent Pelletier <plr.vincent@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: =?windows-1252?Q?Re=3A_ext4_bug_=3F_=22Intel_320_SSD?=
 =?windows-1252?Q?_write_performance_=96_contd=2E=22?=
References: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com> <20111031210951.GK16825@thunk.org>
In-Reply-To: <20111031210951.GK16825@thunk.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec799fad7e513f2ea1aec1e3a463c8c6d297350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 05:09 PM, Ted Ts'o wrote:
> On Mon, Oct 31, 2011 at 09:38:37PM +0100, Vincent Pelletier wrote:
>    
>> Reading this blog post[1], I thought the "2nd iteration" results could be
>> considered a bug in mkfs.ext4 (and possibly any mkfs implementation):
>> shouldn't mkfs run [FI]TRIM on its target before creating filesystem
>> structure ?
>>      
> It's not enabled by default, because there are crappy SSD's out there
> where use of the TRIM command will turn them into bricks.  (No, it's
> not the Intel X-25 drives that I'm worried about.)
>
> So I (and the distributions) don't want to make it the default, since
> if you buy crap drives and then mke2fs turns them into bricks, who are
> you likely to blame?  The crap SSD manufacturer?  Yourself for trying
> to buy SSD's on the cheap?  Or the program that issued the TRIM
> command?
>
> You can enable the trim behaviour by default by adding to your
> /etc/mke2fs.conf file:
>
> [defaults]
> 	discard = true
>
> But then it's on your head if anything bad happens.  :-/
>
>          	      	      	      - Ted
>
>    
<snip>

What about using discard in fstab like:
LABEL=/ /                      ext4    
defaults,discard,noatime,nodiratime        1 1

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



