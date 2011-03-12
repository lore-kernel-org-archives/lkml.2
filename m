Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1CLAkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 19:40:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56693 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1CLAkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 19:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tEWvfDuJGTxMsjHGyqjbQaDUhwGL19PdbZj1ltiSD1dDicHGRQYMxNYtS1y5GHv/nO
         MKgUkSIyKhUn0yf56K860D2w+shOWutjstbYF4ZGjtRsFjzmN2VODWTOWEWxfJ9xwXWW
         vlvfNxg9CYQJWHCk1z0I75wu3tZP/YLgTE6Jc=
Message-ID: <4D7AC0FE.8070806@gmail.com>
Date: Fri, 11 Mar 2011 19:40:30 -0500
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>    <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
In-Reply-To: <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 06:45 PM, Indan Zupancic wrote:
> On Fri, March 11, 2011 12:55, Arnd Bergmann wrote:
>> On Friday 11 March 2011, Indan Zupancic wrote:
>>>>        http://marc.info/?l=linux-fsdevel&amp;m=127970513829285&amp;w=2
>>> The patch there seems much more reasonable than introducing a whole
>>> new systemcall just for 20 lines of kernel code. New system calls are
>>> added too easily nowadays.
>> The only problem with adding new system calls is that we are stuck
>> with the interface until the end of time, so we must be sure not
>> to get it wrong. The same thing is true for any other interface
>> such as ioctl or extensions to existing system calls. People usually
>> get away with adding new ioctls more easily because it is less
>> obvious when they are added.
> Agreed.
>
> I'm not sure this feature is important enough to add. I can't really
> think of a regular use case where this would be useful, generally
> it's transparent on which mount files are. Add symlinks, and you
> give users a lot of rope. Any user has to make sure that all the
> files they want to sync are on the same file system.
>
> About the arguments against sync(2):
>
>>   - On machines with many mounts, it is not at all uncommon for some of
>>     them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>>     those and may never get to the one you do care about (e.g., /).
> It would be better to fix NFS, or mount it with the fsc option (assuming
> a sync will write to the local cache instead of hanging forever then).
>
>>   - Some applications write lots of data to the file system and then
>>     want to make sure it is flushed to disk.  Calling fsync(2) on each
>>     file introduces unnecessary ordering constraints that result in a large
>>     amount of sub-optimal writeback/flush/commit behavior by the file
>>     system.
> You can use sync_file_range() on those files to schedule the writes
> and then do the fsync(2) as usual (both on files and dirs).
>
> If there still is a good reason to implement this, please don't add it
> as a new system call, but add it to sync_file_range(), as that seems
> the best place for odd file synchronisation operations.
>
> Greetings,
>
> Indan
>
>
> --

Hi Indan,

I think that you missed the point of the extension.

Ric

