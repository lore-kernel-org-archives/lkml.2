Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1DPOpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:45:42 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43671 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1DPOpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f605k0mcGhM6XepKyn8DWRJ+vMtgp9TIZVUej0tTNk81O3VbuB7CeeI0So8iSqnaZk
         YaiHOfeL8Zu0tHNkAl8YhLI59tUPJFrgg+lvbjJPRK5LKUyBuYoSn+jzViEgw23H3NKw
         H0rHVpHWfCWgxJNV95EZMuDC9h2qglxGh2wvg=
MIME-Version: 1.0
In-Reply-To: <61322.1302964434@localhost>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
	<20110416135912.GA1044@merkur.ravnborg.org>
	<BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
	<61322.1302964434@localhost>
Date: Sat, 16 Apr 2011 16:45:33 +0200
Message-ID: <BANLkTimSa7=HiSKET4FSR5zqa1mXf2xGFw@mail.gmail.com>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: Francis Moreau <francis.moro@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 16, 2011 at 4:33 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 16 Apr 2011 16:04:57 +0200, Francis Moreau said:
>
>> For example a user can do:
>>
>>   $ make ARCH=arm CROSS_COMPILE=arm-linux-
>>
>> Then call my script and expect it to pass the same flags to make.
>
> Odd, don't ARCH and CROSS_COMPILE get saved in the .config?
>

I could but not always since it can be passed to the command line.

> What *are* you trying to pass to kbuild that isn't either saved in the .config
> or deduced at build time (the cross-compile gets saved, stuff like "where is
> python?" is deduced).  Is there a *real* problem you're hitting here, or is
> it merely theoretical?

Again, I'd like to know how the makefile has been called the last time it run.

Some flags can be passed and influence the rebuild process and I don't
want my script to rebuild the whole kernel because my script doesn't
invoke the makefile as the user (command line) did.

For example, user did:

  $ make CC=distcc

then call my script:

  $ my-script

which in its turn does:

  $ make

then the whole kernel is rebuilt..

Thanks
-- 
Francis
