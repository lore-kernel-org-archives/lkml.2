Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab0FURFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:05:46 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:55965 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab0FURFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:05:45 -0400
Date: Mon, 21 Jun 2010 12:05:36 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Manfred Spraul <manfred@colorfullife.com>
cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
In-Reply-To: <4C1CA49B.7020104@colorfullife.com>
Message-ID: <alpine.DEB.2.00.1006211155540.7407@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <4C1CA49B.7020104@colorfullife.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=------------090108050203040708000600
Content-ID: <alpine.DEB.2.00.1006211155541.7407@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--------------090108050203040708000600
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1006211155542.7407@router.home>

On Sat, 19 Jun 2010, Manfred Spraul wrote:

> What are the semaphore values?
>
> Could you run
> $ ipcs
linux-2.6$ ipcs

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status
0x00000000 0          root       777        135168     0
0x00000000 163841     root       777        135168     2
0x00000000 327682     christoph  600        393216     2          dest
0x00000000 360451     christoph  600        393216     2          dest
0x00000000 393220     christoph  600        393216     2          dest
0x00000000 425989     christoph  600        393216     2          dest
0x00000000 458758     christoph  600        393216     2          dest
0x00000000 491527     christoph  600        393216     2          dest
0x00000000 524296     christoph  600        393216     2          dest
0x00000000 557065     christoph  600        393216     2          dest
0x00000000 589834     christoph  600        393216     2          dest
0x00000000 622603     christoph  600        393216     2          dest
0x00000000 655372     christoph  600        393216     2          dest
0x00000000 688141     christoph  600        393216     2          dest
0x00000000 720910     christoph  600        393216     2          dest
0x00000000 753679     christoph  600        393216     2          dest
0x00000000 786448     christoph  600        4          2          dest
0xcbc384f8 819217     christoph  600        64528      1
0x00000000 851986     christoph  600        4          2          dest
0x00000000 884755     christoph  600        4          2          dest
0x00000000 917524     christoph  600        393216     2          dest
0x00000000 950293     christoph  600        393216     2          dest
0x00000000 5537814    christoph  666        31620      3          dest
0x00000000 5275672    christoph  666        376320     1          dest
0x00000000 5341209    christoph  666        376320     2          dest

------ Semaphore Arrays --------
key        semid      owner      perms      nsems
0x5e8387d1 65536      christoph  600        1
0xcbc384f8 32769      christoph  600        1

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages
0x5e8387cf 65536      christoph  600        0            0
0x5e8387d0 98305      christoph  600        0            0

> $ cat /proc/sysvipc/sem

linux-2.6$ cat /proc/sysvipc/sem
       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime
1585678289      65536   600          1  1000  1000  1000  1000 1277138991 1277138892
-876378888      32769   600          1  1000  1000  1000  1000 1277139467 1277138069


> $ ./getall 32768 -v
>
> getall is attached.

linux-2.6$ ~/getall 65536 -v
getall <id> [-v]
found 1 semaphores.
   0:   0 (cnt  10 zcnt   0)

linux-2.6$ ~/getall 32769 -v
getall <id> [-v]
found 1 semaphores.
   0:   1 (cnt   0 zcnt   0)

The process is "dash". Could have something to do with "fakeroot"

christoph@JTCHITW00139:/proc/27878$ cat maps
00400000-00418000 r-xp 00000000 08:21 253992                             /bin/dash
00617000-00618000 r--p 00017000 08:21 253992                             /bin/dash
00618000-00619000 rw-p 00018000 08:21 253992                             /bin/dash
00619000-0061c000 rw-p 00000000 00:00 0
024b6000-024d7000 rw-p 00000000 00:00 0                                  [heap]
2b03c4959000-2b03c4979000 r-xp 00000000 08:21 6259766                    /lib/ld-2.11.1.so
2b03c4979000-2b03c497b000 rw-p 00000000 00:00 0
2b03c4b79000-2b03c4b7a000 r--p 00020000 08:21 6259766                    /lib/ld-2.11.1.so
2b03c4b7a000-2b03c4b7b000 rw-p 00021000 08:21 6259766                    /lib/ld-2.11.1.so
2b03c4b7b000-2b03c4b7c000 rw-p 00000000 00:00 0
2b03c4b7c000-2b03c4b85000 r-xp 00000000 08:21 5447953                    /usr/lib/libfakeroot/libfakeroot-sysv.so
2b03c4b85000-2b03c4d84000 ---p 00009000 08:21 5447953                    /usr/lib/libfakeroot/libfakeroot-sysv.so
2b03c4d84000-2b03c4d85000 r--p 00008000 08:21 5447953                    /usr/lib/libfakeroot/libfakeroot-sysv.so
2b03c4d85000-2b03c4d86000 rw-p 00009000 08:21 5447953                    /usr/lib/libfakeroot/libfakeroot-sysv.so
2b03c4da4000-2b03c4f1c000 r-xp 00000000 08:21 6260729                    /lib/libc-2.11.1.so
2b03c4f1c000-2b03c511c000 ---p 00178000 08:21 6260729                    /lib/libc-2.11.1.so
2b03c511c000-2b03c5120000 r--p 00178000 08:21 6260729                    /lib/libc-2.11.1.so
2b03c5120000-2b03c5121000 rw-p 0017c000 08:21 6260729                    /lib/libc-2.11.1.so
2b03c5121000-2b03c5127000 rw-p 00000000 00:00 0
2b03c5127000-2b03c5129000 r-xp 00000000 08:21 6260732                    /lib/libdl-2.11.1.so
2b03c5129000-2b03c5329000 ---p 00002000 08:21 6260732                    /lib/libdl-2.11.1.so
2b03c5329000-2b03c532a000 r--p 00002000 08:21 6260732                    /lib/libdl-2.11.1.so
2b03c532a000-2b03c532b000 rw-p 00003000 08:21 6260732                    /lib/libdl-2.11.1.so
2b03c532b000-2b03c532d000 rw-p 00000000 00:00 0
7fff258b3000-7fff258d5000 rw-p 00000000 00:00 0                          [stack]
7fff2598f000-7fff25990000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]



--------------090108050203040708000600
Content-Type: TEXT/PLAIN; NAME=getall.c
Content-ID: <alpine.DEB.2.00.1006211155543.7407@router.home>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=getall.c

/*

 * Copyright (C) 1999 by Manfred Spraul.

 * 

 * Redistribution of this file is permitted under the terms of the GNU 

 * General Public License (GPL)

 * $Header: /home/manfred/cvs-tree/manfred/ipcsem/getall.c,v 1.2 2001/02/27 15:44:32 manfred Exp $

 */



#include <sys/sem.h>

#include <stdlib.h>

#include <stdio.h>

#include <errno.h>

#include <string.h>

#include <assert.h>



#define TRUE	1

#define FALSE	0



union semun {

	int val;

	struct semid_ds *buf;

	unsigned short int *array;

	struct seminfo* __buf;

};





int main(int argc,char** argv)

{

	int id;

	int key;

	int res;

	int nsems;



	printf("getall <id> [-v]\n");

	if(argc < 2 || argc > 3) {

		printf("Invalid parameters.\n");

		return 1;

	}

	if (argc == 3 && strcmp(argv[2], "-v")) {

		printf("Invalid parameters.\n");

		return 1;

	}

	key = atoi(argv[1]);

	if(key < 0) {

		printf("Invalid parameters.\n");

		return 1;

	}

/*	id = semget(key,1,0);

	if(id == -1) {

		printf(" findkey() failed.\n");

		return 1;

	} */

	id = key;

	{

		union semun arg;

		struct semid_ds info;



		arg.buf = &info;

		res = semctl(id,0,2,arg);



		if(res==-1) {

			printf("semctl(2) failed (%d).\n",errno);

			return 1;

		}

		nsems = info.sem_nsems;

		printf("found %d semaphores.\n",nsems);

	}

	{

		union semun arg;

		unsigned short *pv;

		int i;

		pv = malloc(sizeof(unsigned short)*nsems);

		arg.array = pv;

		res = semctl(id,nsems, GETALL, arg);

		if(res==-1) {

			printf("GETALL failed.\n");

			return 1;

		}

		for(i=0;i<nsems;i++) {

			if (argc == 3) {

				printf(" %3d: %3d (cnt %3d zcnt %3d)\n",

					i, pv[i], semctl(id, i, GETNCNT),

					semctl(id, i, GETZCNT));

			} else {

				if(i%16 == 0)

					printf("\n 0x%4.4x:",i);

				printf(" %3d",pv[i]);

			}

		}

		printf("\n");

	}

	return 0;

}


--------------090108050203040708000600--
