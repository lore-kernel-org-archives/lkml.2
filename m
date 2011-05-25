Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1EYUSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:18:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54134 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1EYUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=E8QUxrwlxkdS5O2zZ4hPpOjxm6vqRsR9ZIdFBHbj+QLGUXQ5/DfLK01IlD04i2IvkK
         VCGsHe2fWSHaxyQHPEy2KqEZb60Q6j/zexAcKC73IRgDccmDfHb38BlP9n71Gs0hxD2u
         6cZQQjsMc67BThT9uq1kKL+pC7BFj9+MqCaAs=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 25 May 2011 16:17:54 -0400
X-Google-Sender-Auth: Ujj8ouHh8hgCvFExswTOGNoD898
Message-ID: <BANLkTinptn4-+u+jgOr2vf2iuiVS3mmYXA@mail.gmail.com>
Subject: Easy portable testcase! (Re: Kernel falls apart under light memory
 pressure (i.e. linking vmlinux))
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: minchan.kim@gmail.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 8:43 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Unfortnately, this log don't tell us why DM don't issue any swap io. ;-)
> I doubt it's DM issue. Can you please try to make swap on out of DM?
>
>

I can do one better: I can tell you how to reproduce the OOM in the
comfort of your own VM without using dm_crypt or a Sandy Bridge
laptop.  This is on Fedora 15, but it really ought to work on any
x86_64 distribution that has kvm.  You'll probably want at least 6GB
on your host machine because the VM wants 4GB ram.

Here's how:

Step 1: Clone git://gitorious.org/linux-test-utils/reproduce-annoying-mm-bug.git

(You can browse here:)
https://gitorious.org/linux-test-utils/reproduce-annoying-mm-bug

Instructions to reproduce the mm bug:

Step 2: Build Linux v2.6.38.6 with config-2.6.38.6 and the patch
0001-Minchan-patch-for-testing-23-05-2011.patch (both files are in the
git repo)

Step 3: cd back to reproduce-annoying-mm-bug

Step 4: Type this.

$ make
$ qemu-kvm -m 4G -smp 2 -kernel <linux_dir>/arch/x86/boot/bzImage
-initrd initramfs.gz

Step 5: Wait for the VM to boot (it's really fast) and then run ./repro_bug.sh.

Step 6: Wait a bit and watch the fireworks.  Note that it can take a
couple minutes to reproduce the bug.

Tested on my Sandy Bridge laptop and on a Xeon W3520.

For whatever reason, on my laptop without the VM I can hit the bug
almost instantaneously.  Maybe it's because I'm using dm-crypt on my
laptop.

--Andy

P.S.  I think that the mk_trivial_initramfs.sh script is cute, and
maybe I'll try to flesh it out and turn it into a real project some
day.
