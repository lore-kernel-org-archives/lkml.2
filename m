Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0LZXSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:18:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46612 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0LZXSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RAOpXmgLB7U5l4El/vz/19BH4cYOgxTh62CTsuL+LAEUzqKu3YRU3F8U6rOvmnsg0s
         jVw8uiOQvTU8Bo3CD3/redqNhKdhQCPLdBYiewPDoZQnztj+LOOl1p8rAwwBGn27tBhI
         vBJoVGj5ERIeRWIbN3PWdbbvaF1Ax6CXIP+jY=
MIME-Version: 1.0
In-Reply-To: <20101226214037.GB18227@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home>
 <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
 <20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain>
 <4D14BB36.1030304@msgid.tls.msk.ru> <20101225121407.GA2116@bitwizard.nl> <20101226214037.GB18227@bitwizard.nl>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Sun, 26 Dec 2010 18:17:40 -0500
Message-ID: <AANLkTinKgW_Jpph5NtstCJxA6ZhuTgEc+Juc8YrvE7CE@mail.gmail.com>
Subject: Re: Slow disks.
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Krzysztof Halasa <khc@pm.waw.pl>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 4:40 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> On Sat, Dec 25, 2010 at 01:14:07PM +0100, Rogier Wolff wrote:
>> Out of four partitions on the drive, two are aligned, two are not.
>
> Ooops. I looked wrong. Sorry. All four partitions are mis aligned.
>
>        Roger.

It sounds like you have 3 or 4 separate issues that are each costing
you a factor of 3 or so of pain.

3 * 3 * 3 *3 = 81  ( I don't recall how bad your overall problem was).

I can remember:

Raid 5 - poor choice for 4KB random writes - a factor of 2-4
Misaligned 4KB physical sectors - a factor of 2+
Excessive Head Parking  (You show 100K plus head parks in your smart
data) - (who knows.  It takes a while to un-park the heads and your
heads are parking way too often.)

I think you said it was a 8TB, I know its a pain, but I'd rebuild.  I
don't know how reliable various large drives are currently.  in
2008/2009 they seemed to be horrible and the advice was to use drives
from different vendors, etc so you would be less likely to have a
batch of drives go bad all at once.

Good Luck
Greg
