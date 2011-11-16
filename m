Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1KPJHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:07:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1KPJHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <20111116082759.GD9581@n2100.arm.linux.org.uk>
References: <CAJ8eaTzOtgMzcZeRr6f=+WhtsykK1NZraOGBPoqGncwcAGcTyQ@mail.gmail.com>
	<20111116082759.GD9581@n2100.arm.linux.org.uk>
Date: Wed, 16 Nov 2011 14:37:30 +0530
Message-ID: <CAJ8eaTwCC2e3WKkQzWXhYZ6+SGBg+dabFA380OEoa0vOHM5Odw@mail.gmail.com>
Subject: Re: Crash when memset of shared mapped memory in ARM
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-mm <linux-mm@kvack.org>,
        linux-arm-kernel-request@lists.arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-request@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,
On X86, MIPS
#./tc1
mmap: addr 0x20000000
#
#

On ARM (2.6.35.11 ~ 3.0.2)
#tc1
map: addr 0x20000000
tc1: unhandled page fault (7) at 0x20001000, code 0x817
Bus error (core dumped)
#
#
Debug Information
Pid: 179, comm:                  tc1
CPU: 0    Not tainted  (2.6.35.11 #1)
PC is at 0x400da410
LR is at 0x8858
pc : [<400da410>]    lr : [<00008858>]    psr: 20000010
sp : bed84814  ip : 20001080  fp : 00000000
r10: 40025000  r9 : 00000000  r8 : 00000000
r7 : 20000000  r6 : 20001000  r5 : 00000000  r4 : 0000ef80
r3 : 00000000  r2 : 20010000  r1 : 00000000  r0 : 20000000
Flags: nzCv  IRQs on  FIQs on  Mode USER_32  ISA ARM  Segment user

Process Memory map
00008000-00009000 r-xp 00000000 08:01 153 /usb/sda1/tc1
00010000-00011000 rw-p 00000000 08:01 153 /usb/sda1/tc1
00011000-00032000 rw-p 00011000 08:01 153
20000000-20010000 rw-s 00000000 00:0d 249 /dev/shm/shmem_1234
40000000-4001d000 r-xp 00000000 8b:06 163 /lib/ld-2.11.1.so
4001d000-40021000 rw-p 4001d000 8b:06 163
40024000-40025000 r--p 0001c000 8b:06 163 /lib/ld-2.11.1.so
40025000-40026000 rw-p 0001d000 8b:06 163 /lib/ld-2.11.1.so
40026000-4003b000 r-xp 00000000 8b:06 171 /lib/libpthread-2.11.1.so
4003b000-40042000 ---p 00015000 8b:06 171 /lib/libpthread-2.11.1.so
40042000-40043000 r--p 00014000 8b:06 171 /lib/libpthread-2.11.1.so
40043000-40044000 rw-p 00015000 8b:06 171 /lib/libpthread-2.11.1.so
40044000-40046000 rw-p 40044000 8b:06 171
40046000-4004c000 r-xp 00000000 8b:06 161 /lib/librt-2.11.1.so
4004c000-40053000 ---p 00006000 8b:06 161 /lib/librt-2.11.1.so
40053000-40054000 r--p 00005000 8b:06 161 /lib/librt-2.11.1.so
40054000-40055000 rw-p 00006000 8b:06 161 /lib/librt-2.11.1.so
40055000-4005f000 r-xp 00000000 8b:06 165 /lib/libgcc_s.so.1
4005f000-40067000 ---p 0000a000 8b:06 165 /lib/libgcc_s.so.1
40067000-40068000 rw-p 0000a000 8b:06 165 /lib/libgcc_s.so.1
40068000-40185000 r-xp 00000000 8b:06 174 /lib/libc-2.11.1.so
40185000-4018d000 ---p 0011d000 8b:06 174 /lib/libc-2.11.1.so
4018d000-4018f000 r--p 0011d000 8b:06 174 /lib/libc-2.11.1.so
4018f000-40190000 rw-p 0011f000 8b:06 174 /lib/libc-2.11.1.so
40190000-40193000 rw-p 40190000 8b:06 174
bed63000-bed85000 rw-p befde000 8b:06 174

We wish to know why the same application crashes on ARM ?
On Wed, Nov 16, 2011 at 1:57 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Nov 16, 2011 at 11:05:49AM +0530, naveen yadav wrote:
>> Hi All,
>>
>> I am running below Test program on ARM cortex a9/a8 on kernel version
>> 2.6.35.14 as well as on 3.0.
>>
>> Please find the test case where:
>>
>> 1. Create shared memory object using shm_open(If we use normal open
>> then no problem only problem with shm_open)
>>
>> 2. ftruncate to given size
>>
>> 3. memory map the shared object to given memory address ( I haved
>> tested without MAP_SHARED, MAP_FIXED as well, problem exist)
>>
>> 4. Memset the shared memory (got page fault when accessing the second page)
>>
>>
>>
>>
>> Observation: Only observed in ARM ( i.e not present in MIPS and X86)
>
> Yes, so, what happens?
>
>>
>>
>> #undef NDEBUG
>> #define _GNU_SOURCE
>> #include <unistd.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <sys/ipc.h>
>> #include <sys/shm.h>
>> #include <errno.h>
>> #include <pthread.h>
>> #include <string.h>
>> #include <signal.h>
>> #include <fcntl.h>
>> #include <sys/types.h>
>> #include <sys/mman.h>
>>
>> enum {
>>  SHM_INIT,
>>  SHM_GET
>>  };
>>
>> enum {
>>  PARENT,
>>  CHILD
>>  };
>>
>> #define FIXED_MMAP_ADDR 0x20000000
>> #define MMAP_SIZE     0x10000
>>
>> static int shmid;
>> static char shm_name[100];
>> static int sleep_period = 100000;
>> void * shmem_init(int flag)
>> {
>>       int start = FIXED_MMAP_ADDR;
>>       int memory_size = MMAP_SIZE;
>>       int mode = 0666;
>>       void *addr;
>>       int ret;
>>       sprintf(shm_name, "/shmem_1234");
>>       shmid = shm_open (shm_name, O_RDWR | O_EXCL | O_CREAT | O_TRUNC, mode);
>>       if (shmid < 0) {
>>               if (errno == EEXIST) {
>>                       printf ("shm_open: %s\n", strerror(errno));
>>                               shmid = shm_open (shm_name, O_RDWR, mode);
>>
>>               } else {
>>                       printf("failed to shm_open, err=%s\n", strerror(errno));
>>                       return NULL;
>>               }
>>       }
>>       ret = fcntl (shmid, F_SETFD, FD_CLOEXEC);
>>       if (ret < 0) {
>>               printf("fcntl: %s\n", strerror(errno));
>>               return NULL;
>>       }
>>       ret = ftruncate (shmid, memory_size);
>>       if (ret < 0) {
>>               printf("ftruncate: %s\n", strerror(errno));
>>               return NULL;
>>       }
>>       addr = mmap ((void *)start, memory_size, PROT_READ | PROT_WRITE,
>>                            MAP_SHARED | MAP_FIXED, shmid, 0);
>>       if (addr == MAP_FAILED) {
>>               printf ("mmap: %s\n", strerror(errno));
>>               close (shmid);
>>               shm_unlink (shm_name);
>>               return NULL;
>>       }
>>
>>       if (flag == SHM_INIT){
>>               printf ("mmap: addr %p\n", addr);
>>               /* memset on arm creates a unhandled page fault, works fine on mips */
>>               memset(addr, 0, memory_size);
>>       }
>>       return (void *)addr;
>> }
>>
>> pthread_mutex_t * shmem_mutex_init(int flag)
>> {
>>       pthread_mutex_t * pmutex = (pthread_mutex_t *)shmem_init(flag);
>> #if 0
>>       pthread_mutexattr_t attr;
>>       if (flag == SHM_INIT) {
>>               pthread_mutexattr_init (&attr);
>>               pthread_mutexattr_setpshared (&attr, PTHREAD_PROCESS_SHARED);
>>               pthread_mutexattr_setprotocol (&attr, PTHREAD_PRIO_INHERIT);
>>               pthread_mutexattr_setrobust_np (&attr,
>>                                               PTHREAD_MUTEX_STALLED_NP);
>>               pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_ERRORCHECK);
>>               if (pthread_mutex_init (pmutex, &attr) != 0) {
>>                       printf("Init mutex failed, err=%s\n", strerror(errno));
>>                       pthread_mutexattr_destroy (&attr);
>>                       return NULL;
>>               }
>>       }
>> #endif
>>       return pmutex;
>> }
>>
>> void long_running_task(int flag)
>> {
>>       static int counter = 0;
>>       if (flag == PARENT)
>>               usleep(5*sleep_period);
>>       else
>>               usleep(3*sleep_period);
>>       counter = (counter + 1) % 100;
>>       printf("%d: completed %d computing\n", getpid(), counter);
>> }
>>
>> void sig_handler(int signum)
>> {
>>       close(shmid);
>>       shm_unlink(shm_name);
>>       exit(0);
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>       pthread_mutex_t *mutex_parent, *mutex_child;
>> //    signal(SIGUSR1, sig_handler);
>> //    if (fork()) {
>>               /* parent process */
>>               if ((mutex_parent = shmem_mutex_init(SHM_INIT)) == NULL) {
>>                       printf("failed to get the shmem_mutex\n");
>>                       exit(-1);
>>               }
>> #if 0
>>               while (1) {
>>                       printf("%d: try to hold the lock\n", getpid());
>>                       pthread_mutex_lock(mutex_parent);
>>                       printf("%d: got the lock\n", getpid());
>>                       long_running_task(PARENT);
>>                       pthread_mutex_unlock(mutex_parent);
>>                       printf("%d: released the lock\n", getpid());
>>               }
>> #endif
>> //    } else {
>> #if 0
>>               /* child process */
>>               usleep(sleep_period);
>>               if ((mutex_child = shmem_mutex_init(SHM_GET)) == NULL) {
>>                       printf("failed to get the shmem_mutex\n");
>>                       exit(-1);
>>               }
>>               while (1) {
>>                       printf("%d: try to hold the lock\n", getpid());
>>                       pthread_mutex_lock(mutex_child);
>>                       printf("%d: got the lock\n", getpid());
>>                       long_running_task(CHILD);
>>                       pthread_mutex_unlock(mutex_child);
>>                       printf("%d: released the lock\n", getpid());
>>               }
>> #endif
>> //    }
>>       return 0;
>> }
>
