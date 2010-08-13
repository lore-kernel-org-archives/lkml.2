Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010Ab0HMSYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:24:17 -0400
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:57721 "EHLO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0HMSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:24:16 -0400
Message-ID: <4C658D66.3020801@genband.com>
Date: Fri, 13 Aug 2010 12:22:30 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: defunct processes owned by init, not being reaped ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2010 18:22:31.0418 (UTC) FILETIME=[7E4755A0:01CB3B14]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17568.001
X-TM-AS-Result: No--16.517300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm seeing something very strange.  I've got a system running a modified
2.6.27.18.  There are two tasks that are showing up as defunct but owned
by init:

root@typhoon-base-unit1:/root> ps -ef|grep defun
root    9933   1  0 09:05 ?   00:00:23 [oamFmLogServerP] <defunct>
root    9959   1  0 09:05 ?   00:00:21 [oamFmCliServerP] <defunct>
root   27674 17021  0 18:17 pts/2  00:00:00 grep defun

I tried sending init a SIGCHLD to force it to reap them.  Init tries to
wait for any children, but it doesn't catch them and they remain
defunct--here's the strace of init:

stat64("/dev/initctl", {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
fstat64(10, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
stat64("/dev/initctl", {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
select(11, [10], NULL, NULL, {5, 0})    = ? ERESTARTNOHAND (To be restarted)
--- SIGCHLD (Child exited) @ 0 (0) ---
waitpid(-1, 0xffcbf6ac, WNOHANG)        = 0
sigreturn()                             = ? (mask now [])
time(NULL)                              = 1281723340


Anyone got any ideas what could possibly result in this sort of behaviour?

Thanks,

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
