Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0HJBO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 21:14:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51591 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0HJBOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 21:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=o3G3fQAvpQcTuBsDv0xcDRse6OhJaem/e08wDhdOmGatBSjpQ/oX4jjUCvp/40RzYm
         Z3LI+r4vDZG2Vsl3Re7h2VgRFCfYoGj8+iTlMZIqBQMWX9wmUEEHtPYQPcrCnGi9FXgn
         iXxBgdp5vkuVTWNFPrwoH22t+SXmdvAzp7078=
MIME-Version: 1.0
From: Pistis Valentino <vale.pistis@gmail.com>
Date: Tue, 10 Aug 2010 03:14:30 +0200
Message-ID: <AANLkTi=PB3+RcuaW_fHGcFmta=CN_-WU=WND3LxejY3i@mail.gmail.com>
Subject: find_task_by_pid() problem
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

first of all, thank you all for your work on the Linux kernel.

I am not very practical programming kernel, I admit, but studying how
to build a kernel module I found a possible problem.

I'm using the routine find_task_by_vpid () linux / sched.h (the oldest
find_task_by_pid() don't exist), but when I try to compile the file I
hello_world.c returns an error:

foo@siduxbox: ~ / LPSO / modules / hello_world $ make
make-C / usr/src/linux-2.6.34.2 subdirs = / home / foo / LPSO /
modules / modules hello_world
make [1]: Entering directory `/ usr/src/linux-2.6.34.2 '
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "find_task_by_vpid [/
home/foo/LPSO/modules/hello_world/hello_world_6.ko] undefined!
make [1]: Leaving directory `/ usr/src/linux-2.6.34.2 '
foo@siduxbox: ~ / LPSO / modules / $ hello_world

My surprise is why the function is undefined if it is present in sched.h?

In any case, the function is not defined in sched.c, but directly to
the file pid.c.
Given that pid.h not present the prototype of the function in question.

I'm using Debian Sidux with Linux 2.6.34.2 compiled.

I just can not understand why give me this problem .

I tried to use kernel 2.6.20 for using the old "DEFINE
find_task_by_pid" , but I have problems compiling the kernel and can
not use them.

You could at least tell me if this is a bug or am I not use good routines.


Thank you all


================
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/pid.h>
MODULE_LICENSE ("Dual BSD/GPL");

//static int num=1;
//static char *string="Ciao";

static int p=0;

/*struct task_struct *find_task(pid_t pid)
{
    struct task_struct *task = current;

    do
    { if(task->pid == pid)
        return(task);
        task = task->next_task;
    }
    while(task != current);

    return(NULL);
}
*/
static int hello_init (void)
{
    printk(KERN_ALERT "*********** INIT **********\n");
    printk(KERN_ALERT "Hello, world\n");

    pid_t pid = p;
    struct task_struct *task, *parent;
    task=current;
    parent=find_task_by_vpid(pid);


    printk(KERN_ALERT "Some info from some Process\n");

    //Always initialize the task_struct

    printk("\nThe current task is: %s [%d]\n",task->comm , task->pid);
    printk("\nThe parent task is: %s [%d]\n",parent->comm , parent->pid);

    printk("\nThe credential of current task is:\n Priority = %d\n
euid = %d\n egid = %d\n",task->prio , task->real_cred->euid,
task->real_cred->egid);
    printk("\nThe credential of parent task is:\n Priority = %d\n euid
= %d\n egid = %d\n",parent->prio , parent->real_cred->euid,
parent->real_cred->egid);

    return 0;
}

static void hello_exit (void)
{
    printk(KERN_ALERT "Goodbye, cruel world\n");
    printk(KERN_ALERT "*********** EXIT **********\n");
}

module_init(hello_init);
module_exit(hello_exit);
//module_param(num, int, S_IRUGO);
//module_param(string, charp, S_IRUGO);
module_param(p, int, S_IRUGO);
