Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0GWXQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 19:16:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61301 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0GWXQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 19:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=NFpQSRLyD6i8HZHdWIu8GBeLh27jzudIzCd7NS58Y50EV+YYu91gHPe178Dk4fLUtR
         VuYeCKDyGbyIwhbaWqCBVVKOK9/xHvQz83qUDdUqzXXcZ5dwYJ+vLIwvcu+RZ2umWlV0
         D2ZgLAFqqi4p2tYdYM/FwsdVQVzyjkhvFqH5k=
From: "Sergey V." <sftp.mtuci@gmail.com>
To: dave.bueso@gmail.com
Subject: Re: [RFC] [PATCH procfs] Add process age
Date: Sat, 24 Jul 2010 03:16:30 +0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.6-rt; KDE/4.4.3; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1279907271.4335.3.camel@cowboy> <20100723183549.GA10518@x200> <1279910830.1851.5.camel@cowboy>
In-Reply-To: <1279910830.1851.5.camel@cowboy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007240316.30892.sftp.mtuci@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 of July 2010 22:47:10 Davidlohr Bueso wrote:
> On Fri, 2010-07-23 at 21:35 +0300, Alexey Dobriyan wrote:
> > On Fri, Jul 23, 2010 at 01:47:51PM -0400, Davidlohr Bueso wrote:
> > > This patch exports a process's age, in seconds, adding a /proc/#/age 
file.
> > 
> > What for?
> 
> I have not found any straight way to get the run time of a processes,
> without having to interpret the start_time entry in /proc/#/stat and
> manually subtract the uptime from it.

Agree. I thing this feature can be useful in some cases.

I have not found better than run something like this:

echo `cat /proc/uptime | awk '{print $1}'` - \
     `cat /proc/$PID/stat | awk '{print $22}'`/100 | bc

> This small file simply aids the users to obtain the information easier
> and quicker. Another alternative would be to add an entry
> in /proc/#/status.
> 
> Davidlohr
