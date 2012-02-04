Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2BDApe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:45:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41996 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2BDApc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:45:32 -0500
MIME-Version: 1.0
Date: Fri, 3 Feb 2012 18:45:31 -0600
Message-ID: <CAEik5nNsct2CL0Pfu8XaBGpZ4UOc-6EWtbk_LO5AxGzK9Vajjg@mail.gmail.com>
Subject: [perf] perf top segfaulting
From: Dan McGee <dpmcgee@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i686, version 3.2-2, but looks like annotate.c hasn't changed much
since. It sometimes happens within 5 seconds of starting perf,
sometimes much later, but almost always if I leave it running I well
come back to it having segfaulted. When ran with gdb here it took
about 3 minutes; I had a 5 second segfault and a 5 minute segfault
before and after this run as well. I'm not sure what triggers it other
than it isn't user input, as I can start `perf top`, not touch it, and
it will eventually segfault.

-Dan

Program received signal SIGSEGV, Segmentation fault.
symbol__inc_addr_samples (sym=0x91ca9e8, map=0x9153010, evidx=0,
addr=385376) at util/annotate.c:73
73      util/annotate.c: No such file or directory.
(gdb) bt
#0  symbol__inc_addr_samples (sym=0x91ca9e8, map=0x9153010, evidx=0,
addr=385376) at util/annotate.c:73
#1  0x08066593 in record_precise_ip (ip=<optimized out>, counter=0,
he=<optimized out>) at builtin-top.c:223
#2  perf_event__process_sample (session=0x827bf50, sample=0xbffff9f4,
evsel=<optimized out>, event=<optimized out>) at builtin-top.c:801
#3  perf_session__mmap_read_idx (self=0x827bf50, idx=0) at builtin-top.c:825
#4  0x08068489 in perf_session__mmap_read (self=0x827bf50) at builtin-top.c:839
#5  __cmd_top () at builtin-top.c:1003
#6  cmd_top (argc=<optimized out>, argv=0xbffffd38, prefix=0x0) at
builtin-top.c:1274
#7  0x08055e90 in run_builtin (p=0x80f2624, argc=1, argv=0xbffffd38)
at perf.c:286
#8  0x08055651 in handle_internal_command (argv=0xbffffd38, argc=1) at
perf.c:358
#9  run_argv (argv=0xbffffbd8, argcp=0xbffffbdc) at perf.c:402
#10 main (argc=1, argv=0xbffffd38) at perf.c:512
(gdb) bt full
#0  symbol__inc_addr_samples (sym=0x91ca9e8, map=0x9153010, evidx=0,
addr=385376) at util/annotate.c:73
        offset = 4294557696
        h = 0xb6a8101c
        __func__ = "symbol__inc_addr_samples"
#1  0x08066593 in record_precise_ip (ip=<optimized out>, counter=0,
he=<optimized out>) at builtin-top.c:223
        sym = 0x91ca9e8
#2  perf_event__process_sample (session=0x827bf50, sample=0xbffff9f4,
evsel=<optimized out>, event=<optimized out>) at builtin-top.c:801
        he = 0xfff9c000
        parent = 0x0
        machine = 0x0
        err = <optimized out>
        origin = <optimized out>
        ip = 3076591968
        al = {thread = 0x91fa360, map = 0x91fa650, sym = 0x91ca9e8,
addr = 794976, level = 46 '.', filtered = false, cpumode = 2 '\002',
cpu = -1}
#3  perf_session__mmap_read_idx (self=0x827bf50, idx=0) at builtin-top.c:825
        sample = {ip = 3076591968, pid = 16947, tid = 16947, time =
18446744073709551615, addr = 0, id = 18446744073709551615, stream_id =
18446744073709551615, period = 1057945,
          cpu = 4294967295, raw_size = 4294967295, raw_data = 0x0,
callchain = 0x8}
        evsel = <optimized out>
        event = <optimized out>
        ret = -1230499812
        __PRETTY_FUNCTION__ = "perf_session__mmap_read_idx"
#4  0x08068489 in perf_session__mmap_read (self=0x827bf50) at builtin-top.c:839
        i = <optimized out>
#5  __cmd_top () at builtin-top.c:1003
        hits = <optimized out>
        thread = 3075533632
#6  cmd_top (argc=<optimized out>, argv=0xbffffd38, prefix=0x0) at
builtin-top.c:1274
        pos = <optimized out>
        status = -12
#7  0x08055e90 in run_builtin (p=0x80f2624, argc=1, argv=0xbffffd38)
at perf.c:286
        status = <optimized out>
        st = {st_dev = 13258589575124611012, __pad1 = 49030, __st_ino
= 3087003588, st_mode = 3086926771, st_nlink = 3087006384, st_uid =
3079435296, st_gid = 1, st_rdev = 1,
          __pad2 = 256, st_size = -4611691086352719864, st_blksize =
-1073742952, st_blocks = 577833303592140800, st_atim = {tv_sec =
135210216, tv_nsec = 1}, st_mtim = {
            tv_sec = 135105751, tv_nsec = -1}, st_ctim = {tv_sec =
-1213274024, tv_nsec = 0}, st_ino = 135811744}
#8  0x08055651 in handle_internal_command (argv=0xbffffd38, argc=1) at
perf.c:358
        p = 0x80f2624
        cmd = 0xbffffe6b "top"
        i = <optimized out>
        commands = {{cmd = 0x80d20f7 "buildid-cache", fn = 0x805e8a0
<cmd_buildid_cache>, option = 0}, {cmd = 0x80ce581 "buildid-list", fn
= 0x805e320 <cmd_buildid_list>,
            option = 0}, {cmd = 0x80ce58e "diff", fn = 0x8058630
<cmd_diff>, option = 0}, {cmd = 0x80ce593 "evlist", fn = 0x8058a60
<cmd_evlist>, option = 0}, {
            cmd = 0x80ce3ea "help", fn = 0x8059420 <cmd_help>, option
= 0}, {cmd = 0x80d13b1 "list", fn = 0x805e920 <cmd_list>, option = 0},
{cmd = 0x80d6b7c "record",
            fn = 0x8060360 <cmd_record>, option = 0}, {cmd = 0x80d5a46
"report", fn = 0x8060d90 <cmd_report>, option = 0}, {cmd = 0x80ce59a
"bench", fn = 0x8056850 <cmd_bench>,
            option = 0}, {cmd = 0x80ce5a0 "stat", fn = 0x8062950
<cmd_stat>, option = 0}, {cmd = 0x80ce5a5 "timechart", fn = 0x8065550
<cmd_timechart>, option = 0}, {
            cmd = 0x80ce5af "top", fn = 0x8067de0 <cmd_top>, option =
0}, {cmd = 0x80ceb3b "annotate", fn = 0x8056350 <cmd_annotate>, option
= 0}, {cmd = 0x80ce3f1 "version",
            fn = 0x807c780 <cmd_version>, option = 0}, {cmd =
0x80d5b37 "script", fn = 0x806a5f0 <cmd_script>, option = 0}, {cmd =
0x80ce5b3 "sched", fn = 0x805c5d0 <cmd_sched>,
            option = 0}, {cmd = 0x80ce5b9 "probe", fn = 0x806b740
<cmd_probe>, option = 0}, {cmd = 0x80ce5bf "kmem", fn = 0x806cf80
<cmd_kmem>, option = 0}, {
            cmd = 0x80d9295 "lock", fn = 0x806e180 <cmd_lock>, option
= 0}, {cmd = 0x80ce5c4 "kvm", fn = 0x806eaf0 <cmd_kvm>, option = 0},
{cmd = 0x80ce5c8 "test",
            fn = 0x8071880 <cmd_test>, option = 0}, {cmd = 0x80ce5cd
"inject", fn = 0x8071ed0 <cmd_inject>, option = 0}}
#9  run_argv (argv=0xbffffbd8, argcp=0xbffffbdc) at perf.c:402
        done_alias = 0
#10 main (argc=1, argv=0xbffffd38) at perf.c:512
        done_help = 0
        was_alias = 0
        cmd = 0xbffffe6b "top"
