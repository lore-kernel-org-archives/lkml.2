Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1CJQak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:30:40 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:48491 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1CJQaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:30:39 -0500
Message-ID: <4D78FCA6.7010000@eukrea.com>
Date: Thu, 10 Mar 2011 17:30:30 +0100
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-1?Q?M=E1rio_Isidoro?= <marioisidoro@gmail.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH n_gsm] GSM Mux in non-transparent mode
References: <1299724790.1800.135.camel@Paio> <20110310110658.0a46d19d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110310110658.0a46d19d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There is a problem that happens if the process that is holding the
>> attached line discipline tries to detach it before a process using a
>> virtual com manages to close it. Both processes end up dealocked. I
>> think this has to do with the tty lock. I don't have the backtrace with
>> me

here is the log I get here :

[ 1051.950000] ------------[ cut here ]------------
[ 1051.950000] WARNING: at drivers/tty/tty_mutex.c:31 tty_lock+0x30/0x50()
[ 1051.960000] Modules linked in:
[ 1051.960000] [<c0029478>] (unwind_backtrace+0x0/0xe4) from [<c0034f30>] 
(warn_slowpath_common+0x4c/0x64)
[ 1051.970000] [<c0034f30>] (warn_slowpath_common+0x4c/0x64) from [<c0034f60>] 
(warn_slowpath_null+0x18/0x1c)
[ 1051.980000] [<c0034f60>] (warn_slowpath_null+0x18/0x1c) from [<c031550c>] 
(tty_lock+0x30/0x50)
[ 1051.990000] [<c031550c>] (tty_lock+0x30/0x50) from [<c01af5b0>] 
(__tty_hangup+0x78/0x47c)
[ 1052.000000] [<c01af5b0>] (__tty_hangup+0x78/0x47c) from [<c01ba69c>] 
(gsm_cleanup_mux+0x198/0x214)
[ 1052.010000] [<c01ba69c>] (gsm_cleanup_mux+0x198/0x214) from [<c01baaf4>] 
(gsmld_close+0x28/0x4c)
[ 1052.020000] [<c01baaf4>] (gsmld_close+0x28/0x4c) from [<c01b5974>] 
(tty_ldisc_close+0x58/0x64)
[ 1052.030000] [<c01b5974>] (tty_ldisc_close+0x58/0x64) from [<c01b5b48>] 
(tty_ldisc_release+0x38/0x70)
[ 1052.040000] [<c01b5b48>] (tty_ldisc_release+0x38/0x70) from [<c01b0e2c>] 
(tty_release+0x41c/0x480)
[ 1052.050000] [<c01b0e2c>] (tty_release+0x41c/0x480) from [<c009667c>] 
(fput+0x108/0x200)
[ 1052.060000] [<c009667c>] (fput+0x108/0x200) from [<c00939c8>] 
(filp_close+0x60/0x6c)
[ 1052.070000] [<c00939c8>] (filp_close+0x60/0x6c) from [<c0036eb8>] 
(put_files_struct+0x80/0xdc)
[ 1052.080000] [<c0036eb8>] (put_files_struct+0x80/0xdc) from [<c0038500>] 
(do_exit+0x1b8/0x6bc)
[ 1052.080000] [<c0038500>] (do_exit+0x1b8/0x6bc) from [<c0038ac4>] 
(do_group_exit+0xc0/0xf4)
[ 1052.090000] [<c0038ac4>] (do_group_exit+0xc0/0xf4) from [<c0044460>] 
(get_signal_to_deliver+0x3ac/0x40c)
[ 1052.100000] [<c0044460>] (get_signal_to_deliver+0x3ac/0x40c) from 
[<c0027190>] (do_signal+0x68/0x614)
[ 1052.110000] [<c0027190>] (do_signal+0x68/0x614) from [<c0027754>] 
(do_notify_resume+0x18/0x60)
[ 1052.120000] [<c0027754>] (do_notify_resume+0x18/0x60) from [<c0024f94>] 
(work_pending+0x24/0x28)
[ 1052.130000] ---[ end trace ac06c34c1914deef ]---

Eric
