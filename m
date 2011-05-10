Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1EJJga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:36:30 -0400
Received: from mx1.uni-trier.de ([136.199.224.17]:47962 "EHLO mx1.uni-trier.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1EJJg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:36:29 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 May 2011 05:36:29 EDT
Message-ID: <4DC904D3.1010906@uni-trier.de>
Date: Tue, 10 May 2011 11:26:43 +0200
From: Marco Weber <marco.weber@uni-trier.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problems with procfs
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know wether i'm right on this list or not, but i didn't know 
where i can find some answers to my problem with procfs.
I'm administrating approx. 60 linux machines (all of them ubuntu 8.04 or 
10.04 LTS). All of them are dedicated servers.
On 2 machines (both ubuntu 10.04 LTS of www.OVH.fr), i've discovered 
some strange filesystem permissions of the /proc directory.
The machine m88 got newly installed with a fresh image by OVH:

root@m88:~# ls -al /proc/
total 4
dr-xr-xr-x 117 root   root      0 2011-05-09 20:49 .
drwxr-xr-x  22 root   root   4096 2011-05-09 20:42 ..
dr-x------   6 root   root      0 2011-05-09 20:50 1
dr-x------   6 root   root      0 2011-05-09 20:50 10
dr-x------   6 root   root      0 2011-05-09 20:50 11
dr-x------   6 root   root      0 2011-05-09 20:50 12
dr-x------   6 root   root      0 2011-05-09 20:50 13
dr-x------   6 root   root      0 2011-05-09 20:50 1359
[...]

As you see the directory has 500 permissions. ( On all other machines 
the /proc has 555 permissions. )
This leads to the strange behavior, that a non-root user cannot see all 
proccesses running:

root@m88:~# su - marco
marco@m88:~$ ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
marco    15773  0.0  0.0  37096  1408 pts/0    S    10:58   0:00 su - marco
marco    15774  5.5  0.0  24180  6876 pts/0    S    10:58   0:00 -su
marco    15799  0.0  0.0  15296  1216 pts/0    R+   10:58   0:00 ps aux
marco@m88:~$

This is the kernel that is running:
root@m88:~# uname -a
Linux m88 2.6.38.2-grsec-xxxx-grs-ipv6-64 #1 SMP Fri Apr 15 17:44:15 UTC 
2011 x86_64 GNU/Linux

And there is something else, that is strange:
root@m88:~# lsmod
Opening /proc/modules: No such file or directory

Does anyone have any idea why this is happening?
Is there maybe a sysctl setting, where i can change the /proc permissions?


Thanks in advance for any reply,
              Marco
