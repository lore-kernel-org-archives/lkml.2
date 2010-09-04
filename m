Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0IDO7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:59:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59956 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab0IDO7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=O5R1VCXGv9G1ZsP1RsSL2fx+FnZl8ZnMIZnaIfdUrkSv740Msyg21uma/sULo7rWGS
         cMElHmewqiQNCzTuX4CxceRpXu7DNRzgbVJ8+3w0C8xODG62LCNFTENkj4WHtP/wGvT4
         bkVirpO6whBFgwKvY6Sz2y2YI8300aKKZo+uQ=
MIME-Version: 1.0
In-Reply-To: <1283592366.1685.50.camel@steven>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <AANLkTik=0wMHh9fg8_vK_Aor40J43mNojvfHadhHObKA@mail.gmail.com>
 <1283590584.1685.39.camel@steven> <AANLkTimYgMotZBbGTvPGSzfo3jjZ_-TeXftVQ6bBzHrT@mail.gmail.com>
 <1283592366.1685.50.camel@steven>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Sep 2010 22:58:43 +0800
Message-ID: <AANLkTim5_vf9Tg1g13HAmiO7zAjPzR6QaJ3k2edQzkCv@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
To: Steven <mqyoung@gmail.com>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 4, 2010 at 17:26, Steven <mqyoung@gmail.com> wrote:
> On Sat, 2010-09-04 at 17:17 +0800, Hui Zhu wrote:
>> On Sat, Sep 4, 2010 at 16:56, Steven <mqyoung@gmail.com> wrote:
>> > On Sat, 2010-09-04 at 11:41 +0800, Hui Zhu wrote:
>> >> BTW, looks GCC and GDB don't want handle the optimization debug
>> >> trouble (all they want is rewrite the GCC in C++ :P).
>> >> So I think make linux kernel can close optimization is better idea, do
>> >> you know some way or some patch to do it?
>> >>
>> >
>> > Just disable CONFIG_CC_OPTIMIZE_FOR_SIZE and modify the Makefile of
>> > kernel:
>> > KBUILD_CFLAGS   += -O2
>> > to
>> > KBUILD_CFLAGS   += -O0
>>
>> Cool,  :)
>>
>> I try just change the compile option of readdir.c to without -O2, it
>> works OK.  I think maybe it's a GDB bug too.
>> Could you try the second issue with gdb 7.2?
>
> I have covered the two issues in the previous mail that I could collect
> both global variables and locals(-O0 kernel + gdb7.2):
>
>        --------
>        (gdb) trace vfs_readdir
>        Tracepoint 3 at 0xc11756a0: file fs/readdir.c, line 24.
>        (gdb) actions
>        Enter actions for tracepoint 3, one per line.
>        End with a line saying just "end".
>        >collect *file
>        >end
>        (gdb) trace fs/readdir.c:29
>        Tracepoint 4 at 0xc11756ca: file fs/readdir.c, line 29.
>        (gdb) actions
>        Enter actions for tracepoint 4, one per line.
>        End with a line saying just "end".
>        >collect res
>        >end
>        (gdb) tstart
>        (gdb) tstop
>        (gdb) tfind
>        Found trace frame 0, tracepoint 3
>        #0  0xc11756a1 in vfs_readdir (file=0xc7b2cf00, filler=0,
>        buf=0x0)
>            at fs/readdir.c:24
>        24              struct inode *inode =
>        file->f_path.dentry->d_inode;
>        (gdb) p *file
>        $4 = {f_u = {fu_list = {next = 0xc6dca500, prev = 0xc7ade480},
>        fu_rcuhead = {
>              next = 0xc6dca500, func = 0xc7ade480}}, f_path = {mnt =
>        0xc6c05300,
>            dentry = 0xc761d440}, f_op = 0xc1709a20, f_lock = {{rlock =
>        {raw_lock = {
>                  slock = 0}}}}, f_count = {counter = 2}, f_flags =
>        624640,
>          f_mode = 29, f_pos = 0, f_owner = {lock = {raw_lock = {lock =
>        16777216}},
>           = 0start = 0, size = 0, async_size = 0,
>            ra_pages = 32, mmap_miss = 0, prev_pos = -1}, f_version =
>        0,
>          f_security = 0xc7b30120, private_data = 0x0, f_ep_links = {
>            next = 0xc7b2cf74, prev = 0xc7b2cf74}, f_mapping =
>        0xc761c74c}
>        (gdb) p res
>        $5 = 0
>        (gdb) tfind
>        Found trace frame 1, tracepoint 4
>        0xc11756cb      29              res =
>        security_file_permission(file, MAY_READ);
>        (gdb) p res
>        $6 = -20
>        --------
>
>
>

Great.  :)

Hui
