Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2I0Pqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:46:46 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:34405 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2I0Pqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:46:44 -0400
Message-ID: <506474D0.9020406@cs.tu-berlin.de>
Date: Thu, 27 Sep 2012 17:46:24 +0200
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120919 Thunderbird/10.0.7
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
References: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de> <20120926211526.GA30261@kroah.com> <506382B0.8040908@cs.tu-berlin.de> <CAPXgP11xwBDSZ9q9thzbXd5xZW_jeq-OW96hSoXFbXQBjQWbqw@mail.gmail.com>
In-Reply-To: <CAPXgP11xwBDSZ9q9thzbXd5xZW_jeq-OW96hSoXFbXQBjQWbqw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050004010908040304050703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050004010908040304050703
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Am 27.09.2012 15:39, schrieb Kay Sievers:
> On Thu, Sep 27, 2012 at 12:33 AM, "Jan H. Schönherr"
> <schnhrr@cs.tu-berlin.de> wrote:
>> "Tested" as in: it fixes my use case: multiple printk()s shortly after each
>> other -- with KERN_prefix but without a newline at the end. Those were
>> sometimes concatenated since that printk-rewrite.
> 
> Please provide the output of /dev/kmsg so we can see what's going on here.

Here we go. Test case attached. (Now I would say, the patch is
lightly to moderately tested.)

======= Results with v3.6-rc7 without patch =========

virtual-parasit ~ # insmod foo.ko; rmmod foo
[  122.965207] newline 1
[  122.965583] newline 2newline 3
[  122.965904] newline 4newline 5
[  122.966221] newline 6newline 7
[  122.966681] newline 8newline 9
[  122.966978] newline 10 continued 1 continued 2 continued 3
[  122.966980] newline 11 continued 4 continued 5 continued 6 continued 7
[  122.966980] newline 12
[  122.966981] newline 13
[  122.966981] newline 15
[  122.966983] newline 16a
[  122.966983] newline 16b
[  122.966983] newline 16c continued 8
[  122.966983] newline 17
[  122.966983] newline 18a
newline 18b
newline 18c continued 9virtual-parasit ~ # insmod foo.ko; rmmod foo

[  128.993048] newline 1newline 2
[  128.993414] newline 3newline 4
[  128.993776] newline 5newline 6
[  128.994009] newline 7
[  128.994010] newline 8
[  128.994010] newline 9
[  128.994011] newline 10 continued 1 continued 2 continued 3
[  128.994012] newline 11 continued 4 continued 5 continued 6 continued 7
[  128.994013] newline 12
[  128.994013] newline 13
[  128.994013] newline 15
[  128.994020] newline 16a
[  128.994020] newline 16b
[  128.994020] newline 16c continued 8
[  128.994020] newline 17
[  128.994020] newline 18a
newline 18b
newline 18c continued 9virtual-parasit ~ # cat /dev/kmsg
<snip>
7,397,122965207,-;newline 1
7,398,122965583,c;newline 2
7,399,122965820,+;newline 3
7,400,122965904,c;newline 4
7,401,122966136,+;newline 5
7,402,122966221,c;newline 6
6,403,122966532,+;newline 7
7,404,122966681,c;newline 8
6,405,122966977,+;newline 9
7,406,122966978,-;newline 10 continued 1 continued 2 continued 3
7,407,122966980,-;newline 11 continued 4 continued 5 continued 6 continued 7
6,408,122966980,-;newline 12
4,409,122966981,-;newline 13
4,410,122966981,-;newline 15
7,411,122966983,-;newline 16a\x0anewline 16b\x0anewline 16c continued 8\x0anewline 17
7,412,122966983,-;newline 18a\x0anewline 18b\x0anewline 18c continued 9
7,413,128993048,c;newline 1
7,414,128993318,+;newline 2
7,415,128993414,c;newline 3
7,416,128993691,+;newline 4
7,417,128993776,c;newline 5
7,418,128994009,+;newline 6
6,419,128994009,-;newline 7
7,420,128994010,-;newline 8
6,421,128994010,-;newline 9
7,422,128994011,-;newline 10 continued 1 continued 2 continued 3
7,423,128994012,-;newline 11 continued 4 continued 5 continued 6 continued 7
6,424,128994013,-;newline 12
4,425,128994013,-;newline 13
4,426,128994013,-;newline 15
7,427,128994020,-;newline 16a\x0anewline 16b\x0anewline 16c continued 8\x0anewline 17

=====================================================

Without the patch results are pretty non-deterministic.
Sometimes also concatenating timestamps, e. g.:

virtual-parasit ~ # insmod foo.ko; rmmod foo
[   29.624176] newline 1newline 2
[   29.624589] newline 3newline 4
[   29.625155] newline 5newline 6
[   29.625572] newline 7newline 8newline 9newline 10 continued 1 continued 2 continued 3newline 11
continued 4 continued 5 continued 6 continued 7[   29.625575] newline 12
[   29.625576] newline 13
[   29.625576] newline 15
[   29.625576] newline 16a
[   29.625576] newline 16b
[   29.625576] newline 16c continued 8
[   29.625577] newline 17newline 18a
[   29.625577] newline 18b
[   29.625577] newline 18c continued 9

7,604,29624176,c;newline 1
7,605,29624449,+;newline 2
7,606,29624589,c;newline 3
7,607,29625051,+;newline 4
7,608,29625155,c;newline 5
7,609,29625479,+;newline 6
6,610,29625572,c;newline 7
7,611,29625572,+;newline 8
6,612,29625572,+;newline 9
7,613,29625573,+;newline 10
4,614,29625573,+; continued 1
4,615,29625573,+; continued 2
4,616,29625574,+; continued 3
7,617,29625574,+;newline 11
4,618,29625574,+; continued 4
4,619,29625574,+; continued 5
4,620,29625575,+; continued 6
4,621,29625575,+; continued 7
6,622,29625575,-;newline 12
4,623,29625576,-;newline 13
4,624,29625576,-;newline 15
7,625,29625576,c;newline 16a\x0anewline 16b\x0anewline 16c
4,626,29625577,+; continued 8\x0anewline 17
7,627,29625577,+;newline 18a\x0anewline 18b\x0anewline 18c
4,628,29625577,+; continued 9

dmesg for this one:

[   29.624176] newline 1newline 2
[   29.624589] newline 3newline 4
[   29.625155] newline 5newline 6
[   29.625572] newline 7newline 8newline 9newline 10 continued 1 continued 2 continued 3newline 11
continued 4 continued 5 continued 6 continued 7<6>[   29.625575] newline 12
[   29.625576] newline 13
[   29.625576] newline 15
[   29.625576] newline 16a
[   29.625576] newline 16b
[   29.625576] newline 16c continued 8
[   29.625577] newline 17newline 18a
[   29.625577] newline 18b
[   29.625577] newline 18c continued 9newline 1



======= Results with v3.6-rc7 with patch ============

virtual-parasit ~ # insmod foo.ko; rmmod foo
[   47.619453] newline 1
[   47.619719] newline 2
[   47.619974] newline 3
[   47.620182] newline 4
[   47.620474] newline 5
[   47.620763] newline 6
[   47.621007] newline 7
[   47.621008] newline 8
[   47.621008] newline 9
[   47.621009] newline 10 continued 1 continued 2 continued 3
[   47.621011] newline 11 continued 4 continued 5 continued 6 continued 7
[   47.621011] newline 12
[   47.621011] newline 13
[   47.621011] newline 15
[   47.621012] newline 16a
[   47.621012] newline 16b
[   47.621012] newline 16c continued 8
[   47.621012] newline 17
[   47.621012] newline 18a
newline 18b
newline 18c continued 9virtual-parasit ~ # insmod foo.ko; rmmod foo

[   49.979192] newline 1
[   49.979630] newline 2
[   49.979876] newline 3
[   49.979876] newline 4
[   49.979877] newline 5
[   49.979877] newline 6
[   49.979877] newline 7
[   49.979878] newline 8
[   49.979878] newline 9
[   49.979878] newline 10 continued 1 continued 2 continued 3
[   49.979879] newline 11 continued 4 continued 5 continued 6 continued 7
[   49.979885] newline 12
[   49.979895] newline 13
[   49.979896] newline 15
[   49.979896] newline 16a
[   49.979896] newline 16b
[   49.979896] newline 16c continued 8
[   49.979897] newline 17
[   49.979897] newline 18a
[   49.979897] newline 18b
[   49.979897] newline 18c continued 9virtual-parasit ~ # cat /dev/kmsg
<snip>
7,397,47619453,-;newline 1
7,398,47619719,c;newline 2
7,399,47619974,-;newline 3
7,400,47620182,c;newline 4
7,401,47620474,-;newline 5
7,402,47620763,c;newline 6
6,403,47621007,-;newline 7
7,404,47621008,-;newline 8
6,405,47621008,-;newline 9
7,406,47621009,-;newline 10 continued 1 continued 2 continued 3
7,407,47621011,-;newline 11 continued 4 continued 5 continued 6 continued 7
6,408,47621011,-;newline 12
4,409,47621011,-;newline 13
4,410,47621011,-;newline 15
7,411,47621012,-;newline 16a\x0anewline 16b\x0anewline 16c continued 8\x0anewline 17
7,412,47621012,-;newline 18a\x0anewline 18b\x0anewline 18c continued 9
7,413,49979192,c;newline 1
7,414,49979630,-;newline 2
7,415,49979876,c;newline 3
7,416,49979876,c;newline 4
7,417,49979877,c;newline 5
7,418,49979877,c;newline 6
6,419,49979877,c;newline 7
7,420,49979878,c;newline 8
6,421,49979878,c;newline 9
7,422,49979878,c;newline 10
4,423,49979879,+; continued 1
4,424,49979879,+; continued 2
4,425,49979879,+; continued 3
7,426,49979879,c;newline 11
4,427,49979880,+; continued 4
4,428,49979880,+; continued 5
4,429,49979880,+; continued 6
4,430,49979880,+; continued 7
6,431,49979885,-;newline 12
4,432,49979895,-;newline 13
4,433,49979896,-;newline 15
7,434,49979896,c;newline 16a\x0anewline 16b\x0anewline 16c
4,435,49979897,+; continued 8\x0anewline 17
7,436,49979897,c;newline 18a\x0anewline 18b\x0anewline 18c
4,437,49979897,+; continued 9


>> I was also hoping that Kay might share his opinion, as the LOG_CONT
>> flag is rather young, and he might have some different plans for it.
> 
> It is a flag that we have not been able to merge a continuation line
> in the buffer, because we had a race with another thread, or the
> console lock was taken for a long time and we couldn't use the merge
> buffer.

But it is also set, if we don't know yet, whether there is going to
be a continuation (printk.c, line 1583):

	log_store(facility, level, lflags | LOG_CONT, 0,
		  dict, dictlen, text, text_len);

This confuses devkmsg_read() and msg_print_text() later on.


> LOG_CONT is used to merge (not intended to be) separate records at
> time we read them from the record buffer, and print them, it is also
> exported as a flag in /dev/kmsg.
> 
> I don't think we can just remove it, we can not get that information
> from the prefix+newlines, they are not sufficient.

Here I disagree. ;)

If we say "if LOG_CONT is set, next message might be a continuation",
then that is similar to saying "there is no newline at the end of this
message". And we would need an additional flag on messages indicating
that a message does not continue a previous message.

If we say "if LOG_CONT is set, this message continues the previous one",
we can also say "there is no prefix on this message". Then on the other
hand, we would need a "whatever comes next, it does not continue this
message"....

However, if you want to be able to fully sort out continuation line races
afterwards and be able to reconstruct a race free output, then I agree
that the current information is not sufficient.

Regards
Jan


--------------050004010908040304050703
Content-Type: text/x-csrc;
 name="foo.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="foo.c"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

static int __init foo_init(void)
{
	printk(KERN_DEBUG "newline 1");
	printk(KERN_DEBUG "newline 2");
	printk(KERN_DEBUG "newline 3");
	printk(KERN_DEBUG "newline 4");
	printk(KERN_DEBUG "newline 5");

	printk(KERN_DEBUG "newline 6");
	printk(KERN_INFO  "newline 7");
	printk(KERN_DEBUG "newline 8");
	printk(KERN_INFO  "newline 9");

	printk(KERN_DEBUG "newline 10");
	printk(KERN_CONT  " continued 1");
	printk(KERN_CONT  " continued 2");
	printk(KERN_CONT  " continued 3");
	printk(KERN_DEBUG "newline 11");
	printk(KERN_CONT  " continued 4");
	printk(           " continued 5");
	printk(           " continued 6");
	printk(           " continued 7");
	printk(KERN_INFO  "newline 12\n");
	printk(KERN_CONT  "newline 13\n");
	printk(KERN_CONT  "newline 15\n");

	printk(KERN_DEBUG "newline 16a\nnewline 16b\nnewline 16c");
	printk(           " continued 8\nnewline 17");
	printk(KERN_DEBUG "newline 18a\nnewline 18b\nnewline 18c");
	printk(           " continued 9");

	return 0;
}

static void __exit foo_exit(void)
{
}

module_init(foo_init);
module_exit(foo_exit);

MODULE_LICENSE("GPL");


--------------050004010908040304050703--
