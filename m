Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab1CaSPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:15:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53464 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1CaSPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=u/PBQNVB+R2LSAYMASAZRFVkuGfnXcMT6CbBlYYVfMruAFnnhasveVa3P0+ld6kDRx
         p2XjOSP2hJldhLLrPJnpW1e6J2nz1kf8zcIff4d7H5+ecnz0+KZFnzQBJWe+FSIe7I2R
         sq0UK5Ou4Vjg7jlsA8j/K6/Kq9YOen5Y2rbwI=
MIME-Version: 1.0
In-Reply-To: <20110331163916.2C6D.A69D9226@jp.fujitsu.com>
References: <4D9281B8.1090904@sgi.com> <20110329181346.d2e1fb3c.akpm@linux-foundation.org>
 <20110331163916.2C6D.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 31 Mar 2011 14:15:24 -0400
Message-ID: <AANLkTinrDjgb9PSuWVjk+dTSp1Te0284MuMHWc+jL_bf@mail.gmail.com>
Subject: Re: [PATCH] bitmap, irq: Add smp_affinity_list interface to /proc/irq
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 03:37, KOSAKI Motohiro wrote:
>> > [If it was up to me, I'd eliminate the bitmask interfaces and just keep the
>> > list interfaces.  That's the stupid interface that's not needed, and far more
>> > shortsighted.]
>>
>> Agree.
>>
>> It's not impossible to remove those interfaces.  My preferred approach
>> is to add a once-per-boot warning printk if anyone uses the old
>> interface and to remove the thing altogether in three or five years.
>>
>> That reminds me.  It's been like ten years.  Someone please delete sys_bdflush().
>
> This?
>
> But to be honest, this long diffstat seems tell me the worth is doubious. ;-)

you dont need to update the arches.  just leave the compat option in
kernel/sys_ni.c.  there is really no overhead at runtime as the func
is aliased to the ENOSYS stub.
-mike
