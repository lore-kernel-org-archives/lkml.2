Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab0HVQjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 12:39:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53964 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0HVQj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 12:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M5FSk4JKy3iHf745WV5moPzt5mKv2Cx5BcUYHTnkXWH866DE/VxnhnoBHTCR/1Qw95
         s30hAoPElX78FbDYtwszbdRs21CHZr6pL0MWVBQFkWqYZI1Nq2vxi8E1vkU0+XJss3Q3
         k3wAFz+c4xIMGFZC9V0T8YqBBbonCn4sVw890=
MIME-Version: 1.0
In-Reply-To: <20100820193211.GE2447@linux.vnet.ibm.com>
References: <AANLkTim1PXibiY98GUdMj-UZLTav+n7GAnJ0Mjn6_5a3@mail.gmail.com>
	<20100820193211.GE2447@linux.vnet.ibm.com>
Date: Sun, 22 Aug 2010 18:39:27 +0200
Message-ID: <AANLkTimN1u2fq3LEEGKQfF_+RkVKtqDbUS70mXTKTSq=@mail.gmail.com>
Subject: Re: 2.6.36-rc1 hangs during XFS barrier test for /
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 9:32 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Aug 20, 2010 at 05:08:17PM +0200, Torsten Kaiser wrote:
>> Hello,
>>
>> after installing 2.6.36-rc1 my system gets stuck during "Mounting root..."
>>
>> I'm using an initramfs to mount the root fs, because I'm using a
>> stacked setup with md (raid1) -> dm-crypt -> xfs.

My initramfs seems to have eaten the real OOPS. It was the (already
reported) "kernel BUG at drivers/scsi/scsi_lib.c:1113".

I will just test with -rc2 again. :-)

>> Strange side effect: sometimes the cursor stops blinking for a few
>> seconds, but then resumes blinking. Each of these blinking stalls are
>> accompanied by a RCU stall message.
>
> This indicates that you have a "longer than average loop", probably
> with interrupts disabled across the loop.  Documentation/RCU/stallwarn.txt
> has more information on this condition.

The stall was detected on CPU #2, the same CPU that got the
scsi_lib-BUG. So that very much just looks like a fallout from that.

Thanks for you tipp, but I think, I will only bother you again, if I'm
still seeing this after that OOPS has gotten fixed.

Thanks,

Torsten
