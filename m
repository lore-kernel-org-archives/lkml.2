Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1FJMCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:02:03 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:42926 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1FJMCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:02:01 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 08:02:00 EDT
Message-ID: <4DF2053F.6080502@itwm.fraunhofer.de>
Date: Fri, 10 Jun 2011 13:51:27 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>	<20110608153208.dc705cda.akpm@linux-foundation.org>	<20110609115934.3c53f78f@notabene.brown>	<20110608205233.ebfedc4d.akpm@linux-foundation.org>	<20110609134947.GD13242@shadowen.org> <20110609123220.6afb9d0f.akpm@linux-foundation.org>
In-Reply-To: <20110609123220.6afb9d0f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: ISO-8859-1
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 09:32 PM, Andrew Morton wrote:
> On Thu, 9 Jun 2011 14:49:47 +0100
> Andy Whitcroft<apw@canonical.com>  wrote:
>
>> On Wed, Jun 08, 2011 at 08:52:33PM -0700, Andrew Morton wrote:
>>
>> The problem with the userspace alternative is that it does not work. I
>> tried to run my live CD on top of unionfs-fuse and the filesystem
>> would fail intermittently leading to random errors during boot.
>
>
> If the implementation is slow or buggy then the appropriate action is
> to speed it up and to fix the bugs, so these are just non-arguments,
> IMO.

Exactly. It is rather sad that people never bothered to file bug reports 
about slow performance issues. I'm one of the upstream authors of 
unionfs-fuse and also use it on my own for live-USB sticks and 
NFS-booted systems and do not have such problems.

>
> If it is demonstrated that the userspace implementation simply cannot
> ever have acceptable performance then OK, we have an argument for a
> kernel driver.

Well, I know rather well were most of the performance issues in 
unionfs-fuse come from (at least the normal issues, not those above 
where it seems to fail at all). And those issues are mostly unrelated to 
user-space, but just due to very simple approaches to get a working 
union implementation at all (neither kernel solution actually does what 
I need...). The main problem is that I barely find spare time to further 
improve unionfs-fuse...

Another real difficulty with user-space implementations are init scripts 
- while it works perfectly with Debian, I always have the feeling that 
RedHat does everything they to make it impossible to use fuse as root 
file system (eventually I always get it working, till the next minor 
release, which breaks all workarounds again).

Anyway, given my lack of time and the resulting slow development of 
unionfs-fuse, distros probably need another solution for their live CDs.


Cheers,
Bernd


