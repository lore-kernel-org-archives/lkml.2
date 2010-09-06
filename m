Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab0IFHVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 03:21:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40638 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0IFHVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 03:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=S62yd7EWY1EiKeguHOYoGaKhf0Z4VU5XdXRXk2NcINNTHMawmo/Pm7c3lMRPHDpXpx
         C9Riy8ptDjUGTZ5Xz+K7u3XcFyxFPTnSpEfdQbfsOEE9KXlBolfZJ2mlR1Nz9TXNcoBv
         IMg2FuACv8yotuIH8wqob7ve0pJ1QF0pjD+Ec=
MIME-Version: 1.0
In-Reply-To: <1283618879.1685.110.camel@steven>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <AANLkTik=0wMHh9fg8_vK_Aor40J43mNojvfHadhHObKA@mail.gmail.com>
 <1283590584.1685.39.camel@steven> <AANLkTimYgMotZBbGTvPGSzfo3jjZ_-TeXftVQ6bBzHrT@mail.gmail.com>
 <1283592366.1685.50.camel@steven> <AANLkTim5_vf9Tg1g13HAmiO7zAjPzR6QaJ3k2edQzkCv@mail.gmail.com>
 <1283616109.1685.98.camel@steven> <AANLkTikpuWov=ee2g4B60HOvCd1ZYcnGhH8jT=ANqHNe@mail.gmail.com>
 <1283618879.1685.110.camel@steven>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 6 Sep 2010 15:21:20 +0800
Message-ID: <AANLkTi=+hB8w8U1dFr-Uy_r+Y7sxao1SGgnWEYvykSUY@mail.gmail.com>
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

Sep  6 15:17:06 teawater kernel: [514552.780031] gtp_kp_pre_handler:
tracepoint 1
Sep  6 15:17:06 teawater kernel: [514552.780034] gtp_parse_x: cmd 23
Sep  6 15:17:06 teawater kernel: [514552.780035] gtp_parse_x: cmd 22
Sep  6 15:17:06 teawater kernel: [514552.780037] gtp_parse_x: cmd c
Sep  6 15:17:06 teawater kernel: [514552.780039]
gtp_action_memory_read: id:1 0000054c 8
Sep  6 15:17:06 teawater kernel: [514552.780043]
gtp_action_memory_read: id:1 read 0000054c 8 get error.
Sep  6 15:17:06 teawater kernel: [514552.780048] gtp_kp_pre_handler:
tracepoint 1 stop.
Sep  6 15:17:06 teawater kernel: [514552.780051] tv_sec: 1283757426 - 2010
Sep  6 15:17:06 teawater kernel: [514552.780053] gtp_kp_pre_handler:
tracepoint 2
Sep  6 15:17:06 teawater kernel: [514552.780055] gtp_parse_x: cmd 23
Sep  6 15:17:06 teawater kernel: [514552.780056] gtp_parse_x: cmd 22
Sep  6 15:17:06 teawater kernel: [514552.780057] gtp_parse_x: cmd c
Sep  6 15:17:06 teawater kernel: [514552.780058]
gtp_action_memory_read: id:2 0000054c 8
Sep  6 15:17:06 teawater kernel: [514552.780061]
gtp_action_memory_read: id:2 read 0000054c 8 get error.
Sep  6 15:17:06 teawater kernel: [514552.780063] gtp_kp_pre_handler:
tracepoint 2 stop.
Sep  6 15:17:06 teawater kernel: [514552.780068] gtp_stop: tracepoint 1
Sep  6 15:17:06 teawater kernel: [514552.792059] gtp_stop: tracepoint 2

(gdb) add-symbol-file ~/kernel/tmp/h/hello.ko 0xf81b9000
add symbol table from file "/home/teawater/kernel/tmp/h/hello.ko" at
	.text_addr = 0xf81b9000
(y or n) y
Reading symbols from /home/teawater/kernel/tmp/h/hello.ko...done.
(gdb) p year
Cannot access memory at address 0x554
(gdb) p tv
Cannot access memory at address 0x54c

Looks GDB didn't get the right address of this val.

Export them maybe handle this issue.

Thanks,
Hui



On Sun, Sep 5, 2010 at 00:47, Steven <mqyoung@gmail.com> wrote:
> On Sun, 2010-09-05 at 00:42 +0800, Hui Zhu wrote:
>> Could you post the other part of this code?  Then I can try to reproduce on it.
>
> hello.c
> ------------------------------------------------
> #include <linux/kthread.h>
> #include <linux/module.h>
> #include <linux/init.h>
>
> static struct task_struct *test_task;
> volatile struct timeval tv;
> int year;
>
> int test_thread(void *data)
> {
>        volatile int cnt = 0;
>        set_current_state(TASK_INTERRUPTIBLE);
>        schedule_timeout(1 * HZ); /* wait for the terminal ready */
>
>        while(1){
>                set_current_state(TASK_INTERRUPTIBLE); /* this is
> required, or thread never sleep*/
>                if(kthread_should_stop()) break;
>
>                year = 2010;
>                do_gettimeofday (&tv);
>                printk("\ntv_sec: %d - %d\n", (int)tv.tv_sec, cnt);
>                cnt++;
>
>                do_gettimeofday (&tv);
>                printk("tv_sec: %d - %d\n", (int)tv.tv_sec, year);
>                cnt++;
>
>                //reschedule after 5 seconds(approximately)
>                schedule_timeout(60 * HZ);
>        }
>
>        return 0;
> }
>
> static int __init mt_init(void)
> {
>        int err;
>        test_task = kthread_create(test_thread, NULL, "test_task");
>        if(IS_ERR(test_task)){
>                printk("Unable to start kernel thread.\n");
>                printk("Unable to start kernel thread.\n");
>                err = PTR_ERR(test_task);
>                test_task = NULL;
>                return err;
>        }
>        wake_up_process(test_task);
>        return 0;
> }
>
>
> static void __exit mt_cleanup(void)
> {
>        if(test_task){
>                kthread_stop(test_task);
>                test_task = NULL;
>        }
> }
>
> module_init(mt_init);
> module_exit(mt_cleanup);
>
> MODULE_LICENSE("GPL");
> ------------------------------------------------
>
>
> Makefile
> ------------------------------------------------
> obj-m := hello.o
>
> KERNELBUILD := /lib/modules/`uname -r`/build
>
> default:
>        make -C $(KERNELBUILD) M=$(shell pwd) modules
>
> clean:
>        rm -rf *.o *.cmd *.ko *.mod.c .tmp-versions *.symvers
> ------------------------------------------------
>
>
>
>> Thanks,
>> Hui
>>
>> On Sun, Sep 5, 2010 at 00:01, Steven <mqyoung@gmail.com> wrote:
>> > Dear All,
>> >
>> > As I mentioned before, I could collect the variables of kernel function
>> > such as vfs_readdir(ext3 is built in kernel not module). And I tried I
>> > could collect variables of kernel's module(such as my ethernet card
>> > driver 3c59x.ko). I will collect these info later.
>> >
>> > BUT, I can not collect the value of my testing module, neither global
>> > nor local. I think there is some thing wrong with my compile option or
>> > Makefile, any one know it? Thanks very much.
>> >
>> > Program:
>> > -------------------------------------------------
>> >  6 volatile struct timeval tv;
>> >  7 int year;
>> >  8
>> >  9 int test_thread(void *data)
>> >  10 {
>> >  11         volatile int cnt = 0;
>> >  12         set_current_state(TASK_INTERRUPTIBLE);
>> >  13         schedule_timeout(1 * HZ); /* wait for the terminal ready */
>> >  14
>> >  15         while(1){
>> >  16                 set_current_state(TASK_INTERRUPTIBLE);
>> >  17                 if(kthread_should_stop()) break;
>> >  18
>> >  19                 year = 2010;
>> >  20                 do_gettimeofday (&tv);
>> >  21                 printk("\ntv_sec: %d - %d\n", (int)tv.tv_sec, cnt);
>> >  22                 cnt++;
>> >  23
>> >  24                 do_gettimeofday (&tv);
>> >  25                 printk("tv_sec: %d - %d\n", (int)tv.tv_sec, year);
>> >  26                 cnt++;
>> >  27
>> >  28                 //reschedule after 5 seconds(approximately)
>> >  29                 schedule_timeout(60 * HZ);
>> >  30         }
>> >  31
>> >  32         return 0;
>> >  33 }
>> > -------------------------------------------------
>> >
>> > Makefile
>> > -------------------------------------------------
>> > obj-m := hello.o
>> >
>> > KERNELBUILD := /lib/modules/`uname -r`/build
>> >
>> > default:
>> >        make -C $(KERNELBUILD) M=$(shell pwd) modules
>> > -------------------------------------------------
>> >
>> >
>> > Screen log
>> > -------------------------------------------------
>> > debian:/home/linux-2.6.33.6# /usr/local/bin/gdb vmlinux
>> > GNU gdb (GDB) 7.2
>> > Copyright (C) 2010 Free Software Foundation, Inc.
>> > License GPLv3+: GNU GPL version 3 or later
>> > <http://gnu.org/licenses/gpl.html>
>> > This is free software: you are free to change and redistribute it.
>> > There is NO WARRANTY, to the extent permitted by law.  Type "show
>> > copying"
>> > and "show warranty" for details.
>> > This GDB was configured as "i686-pc-linux-gnu".
>> > For bug reporting instructions, please see:
>> > <http://www.gnu.org/software/gdb/bugs/>...
>> > Reading symbols from /home/linux-2.6.33.6/vmlinux...[ 3909.310118]
>> > [ 3909.310124] tv_sec: 1283648666 - 16
>> > [ 3909.315385] tv_sec: 1283648666 - 2010
>> > done.
>> > (gdb) target remote /proc/gtp
>> > Remote debugging using /proc/gtp
>> > 0x00000000 in ?? ()
>> > (gdb) add-symbol-file /home/steven/hello/hello.ko 0xc8b2b000
>> > add symbol table from file "/home/steven/hello/hello.ko" at
>> >        .text_addr = 0xc8b2b000
>> > (y or n) y
>> > Reading symbols from /home/steven/hello/hello.ko...done.
>> > (gdb) trace /home/steven/hello/hello.c:22
>> > Tracepoint 1 at 0xc8b2b094: file /home/steven/hello/hello.c, line 22.
>> > (gdb) trace /home/steven/hello/hello.c:26
>> > Tracepoint 2 at 0xc8b2b0c1: file /home/steven/hello/hello.c, line 26.
>> > (gdb) actions 1
>> > Enter actions for tracepoint 1, one per line.
>> > End with a line saying just "end".
>> >>
>> >>collect tv, year, cnt
>> >>end
>> > (gdb) actions 2
>> > Enter actions for tracepoint 2, one per line.
>> > End with a line saying just "end".
>> >>collect tv, year, cnt
>> >>end
>> > (gdb) tstart
>> > [ 4029.328129]
>> > [ 4029.328136] tv_sec: 1283648786 - 20
>> > [ 4029.333456] tv_sec: 1283648786 - 2010
>> > tstop
>> > (gdb) tfind
>> > Found trace frame 0, tracepoint 1
>> > #0  0xc8b2b095 in test_thread (data=0x0)
>> > at /home/steven/hello/hello.c:22
>> > 22                      cnt++;
>> > (gdb) p tv
>> > $1 = {tv_sec = 0, tv_usec = 0}
>> > (gdb) p cnt
>> > $2 = 0
>> > (gdb) p year
>> > $3 = 0
>> > (gdb) tfind
>> > Found trace frame 1, tracepoint 2
>> > 0xc8b2b0c2      26                      cnt++;
>> > (gdb) p cnt
>> > $4 = 0
>> > (gdb) p tv
>> > $5 = {tv_sec = 0, tv_usec = 0}
>> > (gdb) p year
>> > $6 = 0
>> > -------------------------------------------------
>> >
>> > Thanks,
>> > Steven
>> >
>> > On Sat, 2010-09-04 at 22:58 +0800, Hui Zhu wrote:
>> >> On Sat, Sep 4, 2010 at 17:26, Steven <mqyoung@gmail.com> wrote:
>> >> > On Sat, 2010-09-04 at 17:17 +0800, Hui Zhu wrote:
>> >> >> On Sat, Sep 4, 2010 at 16:56, Steven <mqyoung@gmail.com> wrote:
>> >> >> > On Sat, 2010-09-04 at 11:41 +0800, Hui Zhu wrote:
>> >> >> >> BTW, looks GCC and GDB don't want handle the optimization debug
>> >> >> >> trouble (all they want is rewrite the GCC in C++ :P).
>> >> >> >> So I think make linux kernel can close optimization is better idea, do
>> >> >> >> you know some way or some patch to do it?
>> >> >> >>
>> >> >> >
>> >> >> > Just disable CONFIG_CC_OPTIMIZE_FOR_SIZE and modify the Makefile of
>> >> >> > kernel:
>> >> >> > KBUILD_CFLAGS   += -O2
>> >> >> > to
>> >> >> > KBUILD_CFLAGS   += -O0
>> >> >>
>> >> >> Cool,  :)
>> >> >>
>> >> >> I try just change the compile option of readdir.c to without -O2, it
>> >> >> works OK.  I think maybe it's a GDB bug too.
>> >> >> Could you try the second issue with gdb 7.2?
>> >> >
>> >> > I have covered the two issues in the previous mail that I could collect
>> >> > both global variables and locals(-O0 kernel + gdb7.2):
>> >> >
>> >> >        --------
>> >> >        (gdb) trace vfs_readdir
>> >> >        Tracepoint 3 at 0xc11756a0: file fs/readdir.c, line 24.
>> >> >        (gdb) actions
>> >> >        Enter actions for tracepoint 3, one per line.
>> >> >        End with a line saying just "end".
>> >> >        >collect *file
>> >> >        >end
>> >> >        (gdb) trace fs/readdir.c:29
>> >> >        Tracepoint 4 at 0xc11756ca: file fs/readdir.c, line 29.
>> >> >        (gdb) actions
>> >> >        Enter actions for tracepoint 4, one per line.
>> >> >        End with a line saying just "end".
>> >> >        >collect res
>> >> >        >end
>> >> >        (gdb) tstart
>> >> >        (gdb) tstop
>> >> >        (gdb) tfind
>> >> >        Found trace frame 0, tracepoint 3
>> >> >        #0  0xc11756a1 in vfs_readdir (file=0xc7b2cf00, filler=0,
>> >> >        buf=0x0)
>> >> >            at fs/readdir.c:24
>> >> >        24              struct inode *inode =
>> >> >        file->f_path.dentry->d_inode;
>> >> >        (gdb) p *file
>> >> >        $4 = {f_u = {fu_list = {next = 0xc6dca500, prev = 0xc7ade480},
>> >> >        fu_rcuhead = {
>> >> >              next = 0xc6dca500, func = 0xc7ade480}}, f_path = {mnt =
>> >> >        0xc6c05300,
>> >> >            dentry = 0xc761d440}, f_op = 0xc1709a20, f_lock = {{rlock =
>> >> >        {raw_lock = {
>> >> >                  slock = 0}}}}, f_count = {counter = 2}, f_flags =
>> >> >        624640,
>> >> >          f_mode = 29, f_pos = 0, f_owner = {lock = {raw_lock = {lock =
>> >> >        16777216}},
>> >> >           = 0start = 0, size = 0, async_size = 0,
>> >> >            ra_pages = 32, mmap_miss = 0, prev_pos = -1}, f_version =
>> >> >        0,
>> >> >          f_security = 0xc7b30120, private_data = 0x0, f_ep_links = {
>> >> >            next = 0xc7b2cf74, prev = 0xc7b2cf74}, f_mapping =
>> >> >        0xc761c74c}
>> >> >        (gdb) p res
>> >> >        $5 = 0
>> >> >        (gdb) tfind
>> >> >        Found trace frame 1, tracepoint 4
>> >> >        0xc11756cb      29              res =
>> >> >        security_file_permission(file, MAY_READ);
>> >> >        (gdb) p res
>> >> >        $6 = -20
>> >> >        --------
>> >> >
>> >> >
>> >> >
>> >>
>> >> Great.  :)
>> >>
>> >> Hui
>> >
>> >
>
>
>
