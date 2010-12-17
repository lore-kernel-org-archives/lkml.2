Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0LQFVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 00:21:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18430 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0LQFVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 00:21:50 -0500
MIME-Version: 1.0
Message-ID: <deceffd7-c3a8-49a9-b203-4b4d06af1195@default>
Date: Thu, 16 Dec 2010 21:15:07 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Chris Mason <chris.mason@oracle.com>, akpm@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        minchan.kim@gmail.com
Subject: RE: [PATCH V0 1/4] kztmem: simplified radix tree data structure
 support
References: <20101207180653.GA28115@ca-server1.us.oracle.com
 dd88185d-bc2c-4d65-8730-8b1fc712306a@default>
In-Reply-To: <dd88185d-bc2c-4d65-8730-8b1fc712306a@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A monolithic patch containing all of kztmem, cleancache, and frontswap
> that applies cleanly to 2.6.36 can be found at:
> 
> http://oss.oracle.com/projects/tmem/dist/files/kztmem/kztmem-linux-
> 2.6.36-101207.patch
> 
> (Or http://oss.oracle.com/projects/tmem and Downloads and kztmem
> patches)
> 
> I'm a git novice but can prepare a git tree also if desired.
> 
> To try kztmem:
> 
> 1) apply the monolithic patch to 2.6.36
> 2) rebuild your config ensuring that CONFIG_KZTMEM, CONFIG_CLEANCACHE,
>    CONFIG_FRONTSWAP, and CONFIG_ZRAM (for xvMalloc) become enabled
> 3) rebuild and reboot with "kztmem" as a kernel boot parameter
> 4) see /sys/kernel/mm/kztmem/* for statistics... note that with
>    lots of RAM and no swapping, little or no activity will be seen
> 
> As I said, there are known weird bugs that may or may not show
> up in your configuration and build environment, so be prepared
> in advance that the kernel may crash... removing kztmem as
> a boot parameter should disable kztmem and result in a normal boot.
> 
> Thanks in advance for trying and testing (and, if you are so
> inclined, debugging) kztmem!  I'll be happy to answer any
> questions on- or off-list!

FYI, in case anyone was thinking about giving it a spin,
I have just posted an update of the (monolithic) kztmem
patch here:

http://oss.oracle.com/projects/tmem/dist/files/kztmem/kztmem-linux-2.6.36-101207.patch 

I think all the weird bugs and crashes are now gone, though I
have some concurrency rework to do after some feedback from
Jeremy Fitzhardinge, and that's not going to happen until
after the holidays.  So I am posting this intermediate version
if you want to try it, but please hold off on any detailed
code review until I post v1 to lkml/linux-mm.

Thanks,
Dan
