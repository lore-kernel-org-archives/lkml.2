Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2AAN6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 08:58:19 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60240 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2AAN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 08:58:16 -0500
Message-ID: <4F00666D.70904@gmail.com>
Date: Sun, 01 Jan 2012 15:58:05 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: cifs: ls of mount point gives input/output error (probably related
 to CIFS: getdents() broken for large dirs)
References: <4EFBAF99.3010208@gmail.com> <20111228210420.2a422d11@corrin.poochiereds.net> <4EFC413A.80302@gmail.com> <20111229083930.77fafba8@tlielax.poochiereds.net> <4EFC7124.3060900@gmail.com> <4EFD7EBB.2060708@gmail.com> <20111230081120.3f7710f1@tlielax.poochiereds.net> <4EFDFC4E.30102@gmail.com> <20111231065922.05727805@tlielax.poochiereds.net> <4EFF04E3.70200@gmail.com> <4EFF110C.7010302@gmail.com> <20111231202331.2a03bb35@corrin.poochiereds.net> <20120101064449.50277028@tlielax.poochiereds.net>
In-Reply-To: <20120101064449.50277028@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/1/2012 1:44 μμ, Jeff Layton wrote:
> On Sat, 31 Dec 2011 20:23:31 -0500
> Jeff Layton<jlayton@redhat.com>  wrote:
>
>> On Sat, 31 Dec 2011 15:41:32 +0200
>> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>>
>>> On 31/12/2011 2:49 μμ, Konstantinos Skarlatos wrote:
>>>> On Σάββατο, 31 Δεκέμβριος 2011 1:59:22 μμ, Jeff Layton wrote:
>>>>> On Fri, 30 Dec 2011 20:00:46 +0200
>>>>> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>>>>>
>>>>>> On 30/12/2011 3:11 μμ, Jeff Layton wrote:
>>>>>>> On Fri, 30 Dec 2011 11:04:59 +0200
>>>>>>> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>>>>>>>
>>>>>>>> On 29/12/2011 3:54 μμ, Konstantinos Skarlatos wrote:
>>>>>>>>> On Πέμπτη, 29 Δεκέμβριος 2011 3:39:30 μμ, Jeff Layton wrote:
>>>>>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
>>>>>>>>>> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>>>>>>>>>>
>>>>>>>>>>> On 29/12/2011 4:04 πμ, Jeff Layton wrote:
>>>>>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
>>>>>>>>>>>> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> I mount via cifs a windows XP share, df gives me correct sizes,
>>>>>>>>>>>>> but when
>>>>>>>>>>>>> I ls the mount point i get input/output error.
>>>>>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
>>>>>>>>>>>>>
>>>>>>>>>>>>> mount --verbose -t cifs -o
>>>>>>>>>>>>> username=administrator,password=blahblah
>>>>>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
>>>>>>>>>>>>> mount.cifs kernel mount options:
>>>>>>>>>>>>> ip=192.168.0.11,unc=\\192.168.0.11\jobs,,ver=1,user=administrator,pass=********
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> df
>>>>>>>>>>>>> //192.168.0.11/jobs 114464
>>>>>>>>>>>>> 105196 9268 92% /mnt/backups/montaz/jobs
>>>>>>>>>>>>>
>>>>>>>>>>>>> ls /mnt/backups/montaz/jobs/
>>>>>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/output
>>>>>>>>>>>>> error
>>>>>>>>>>>>> total 0
>>>>>>>>>>>>>
>>>>>>>>>>>>> the fun thing is that i can cd to a lower level directory, and ls
>>>>>>>>>>>>> works
>>>>>>>>>>>>> fine there! only the mount point has the problem
>>>>>>>>>>>>>
>>>>>>>>>>>>> ls /mnt/backups/montaz/jobs/test
>>>>>>>>>>>>> total 44K
>>>>>>>>>>>>> drwxr-xr-x 1 root root 0 Apr 30 2010 blah blah/
>>>>>>>>>>>>> ......
>>>>>>>>>>>>>
>>>>>>>>>>>>> kernel version 3.2rc7
>>>>>>>>>>>>>
>>>>>>>>>>>>> this seems to be related to :
>>>>>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
>>>>>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for
>>>>>>>>>>>>> large dirs
>>>>>>>>>>>>>
>>>>>>>>>>>> Hmmm, maybe. What makes you think that it's related? What sort of
>>>>>>>>>>>> server are you seeing this against?
>>>>>>>>>>> Windows XP service pack 2 (greek)
>>>>>>>>>>
>>>>>>>>>> How many files are in the directory?
>>>>>>>>>>
>>>>>>>>> 140 folders and 20 files
>>>>>>>>>
>>>>>>>> Attached is a tcp dump of my session.
>>>>>>> I tried reproducing this here, but wasn't able to. Testing against my
>>>>>>> xp box worked fine.
>>>>>>>
>>>>>>> Most likely, the FIND_FILE responses are falling afoul of the code in
>>>>>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
>>>>>>> complicated and I'm not certain what the problem actually is...
>>>>>>>
>>>>>>> One thing that's interesting is that the total data being sent in the
>>>>>>> request is rather large (16336 bytes). I think that's legit, but maybe
>>>>>>> it's exceeding the end of the buffer once we try to coalesce it.
>>>>>>>
>>>>>>> Would it be possible to get the cFYI output from this test?
>>>>>> I did not get a cFYI output from that test, but i redid a
>>>>>> mount-ls-umount and am attaching the tcpdump
>>>>>> Also here http://pastebin.com/J20uC6kU you can find the cifsFYI and the
>>>>>> contents of /proc/fs/cifs/DebugData form the same test
>>>>>>>
>>>>>>> Is this a regression? Did it work with earlier kernels and only
>>>>>>> recently start failing?
>>>>>>>
>>>>>> I do not know, and i am a bit afraid to downgrade this machine below 3.0
>>>>>> due to some changes arch linux has introduced recently. I can always set
>>>>>> up a few virtual machines though, and i can even request permission from
>>>>>> my company to give you shell access if you like. Which kernel versions
>>>>>> would you like me to test?
>>>>>
>>>>>
>>>>> Ok, that tells us a little:
>>>>>
>>>>> -------------------[snip]---------------------
>>>>> [96268.787078] fs/cifs/cifssmb.c: In FindFirst for
>>>>> [96268.787083] fs/cifs/transport.c: For smb_command 50
>>>>> [96268.787086] fs/cifs/transport.c: Sending smb: total_len 88
>>>>>
>>>>> ...FIND_FIRST command is sent
>>>>>
>>>>> [96268.787690] fs/cifs/connect.c: RFC1002 header 0x1104
>>>>> [96268.787697] fs/cifs/connect.c: missing 12048 bytes from transact2,
>>>>> check next response
>>>>> [96268.787865] fs/cifs/connect.c: RFC1002 header 0x1104
>>>>> [96268.787870] fs/cifs/connect.c: missing 12036 bytes from transact2,
>>>>> check next response
>>>>> [96268.788037] fs/cifs/connect.c: RFC1002 header 0x1104
>>>>> [96268.788042] fs/cifs/connect.c: missing 12036 bytes from transact2,
>>>>> check next response
>>>>> [96268.788371] fs/cifs/connect.c: RFC1002 header 0xdb0
>>>>> [96268.788375] fs/cifs/connect.c: missing 12888 bytes from transact2,
>>>>> check next response
>>>>>
>>>>> ...all four parts of the response are collected here
>>>>>
>>>>> [96268.788391] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50
>>>>> mid=12 state=16
>>>>>
>>>>> ...but the state at this point is MID_RESPONSE_MALFORMED
>>>>>
>>>>> [96268.788395] fs/cifs/cifssmb.c: Error in FindFirst = -5
>>>>> [96268.788397] fs/cifs/readdir.c: initiate cifs search rc -5
>>>>> [96268.788398] fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid
>>>>> = 737644) rc = -5
>>>>>
>>>>> ...which makes readdir return -EIO
>>>>>
>>>>> -------------------[snip]---------------------
>>>>>
>>>>> Based on that, it looks like something in one of these frames caused
>>>>> coalesce_t2() to return an error. I don't see the problem right offhand
>>>>> in the capture, but T2 response handling is pretty complex so it can be
>>>>> hard to see.
>>>>>
>>>>> Would it be possible for you to rebuild your kernel (or just cifs.ko)
>>>>> with this patch? Once you do that, rerun the test with cFYI turned up,
>>>>> and it should help point out what the problem is.
>>>>>
>>>>> Thanks,
>>>>
>>>> Ok i am now rebuilding the kernel and will report when i have results.
>>> http://pastebin.com/scgyDjhT and attached tcpdump
>>
>> Very helpful -- I think I see the bug now. Can you test this patch and
>> let me know if it fixes the problem? You'll need to back out the debug
>> patch first, and then apply this one. If it works, I'll plan to clean
>> this up and send to Steve for inclusion.
>>
>> Thanks...
>>
>
> Actually...that patch is off by 4 bytes. Since we're so late in the
> cycle too, we should probably keep extraneous changes to a minimum.
> I'll probably propose this patch for 3.2 once you've tested it, and
> will spin up a patch to clean up coalesce_t2 for 3.3.
>
> If you're already testing the other one, then it's probably good enough
> to verify the fix. If you haven't tested it yet though, then you should
> probably test this one instead. Either way, let me know soon if you can
> so we can get this into 3.2.

Ok, I tested and it works fine for me. Thanks!

PS: would you like me to send any cFYI or tcpdumps?

Tested-by: Konstantinos Skarlatos<k.skarlatos@gmail.com>

>
> ---------------------------[snip]----------------------------
>
>
> [PATCH] cifs: fix bad buffer length check in coalesce_t2
>
> The current check looks to see if the RFC1002 length is larger than
> CIFSMaxBufSize and fails if it is. The buffer is actually larger than
> that by MAX_CIFS_HDR_SIZE. Fix the check so that it doesn't fail due
> to this.
>
> This bug has been around for a long time, but the fact that we used to
> cap the clients MaxBufferSize at the same level as the server tended
> to paper over it. Commit c974befa changed that however.
>
> Reported-by: Konstantinos Skarlatos<k.skarlatos@gmail.com>
> Signed-off-by: Jeff Layton<jlayton@redhat.com>
> ---
>   fs/cifs/connect.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8cd4b52..27c4f25 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
>   	byte_count = be32_to_cpu(pTargetSMB->smb_buf_length);
>   	byte_count += total_in_buf2;
>   	/* don't allow buffer to overflow */
> -	if (byte_count>  CIFSMaxBufSize)
> +	if (byte_count>  CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
>   		return -ENOBUFS;
>   	pTargetSMB->smb_buf_length = cpu_to_be32(byte_count);
>

