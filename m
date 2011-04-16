Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1DPPrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 11:47:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42278 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1DPPrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 11:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mjb1ZqVes+wST5cIeWahHRKPTael+AQE1WhUgwWRvcQLQzhrYbz9xVMgXk8muZcP3E
         nAZ3CTMaUwtIbpHTjDgTjZTDv3FlrS5f5dmjja5J43gSAJmSsCj9Ny1JDfgWqfLh8J8X
         Euy3J9lDPf5lIWvct1vS7sGosdzd+JAzZ/V2k=
MIME-Version: 1.0
In-Reply-To: <62853.1302966525@localhost>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
	<20110416135912.GA1044@merkur.ravnborg.org>
	<BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
	<61322.1302964434@localhost>
	<BANLkTimSa7=HiSKET4FSR5zqa1mXf2xGFw@mail.gmail.com>
	<62853.1302966525@localhost>
Date: Sat, 16 Apr 2011 17:47:02 +0200
Message-ID: <BANLkTi=pZPvDbffuW1X2qVVP_xk5FzmrQQ@mail.gmail.com>
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

On Sat, Apr 16, 2011 at 5:08 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 16 Apr 2011 16:45:33 +0200, Francis Moreau said:
>
>> For example, user did:
>>   $ make CC=distcc
>> then call my script:
>>   $ my-script
>> which in its turn does:
>>   $ make
>> then the whole kernel is rebuilt..
>
> You have two choices then:
>
> 1)  Allow them to pass stuff to your script:
>
> $ make CC=distcc
> then call my script:
> $ my-script CC=distcc
> which in its turn does:
> $ make "$*"
>
> 2) Find out *why* they're doing a make of the kernel, and then calling your
> script that *again* does a make of the kernel, instead of just calling your
> script and being done with it.

Because the script needs some generated files and rather to ask to the user:

  file X is missing, please run 'make prepare'

I just thought that it would be easier to let the script call make
prepare (this is just an example) automatically.

And from the script point of view, it's just easier to call make
instead of testing for all missing files.

But maybe it's just a bad idea.

> This sounds like you have a poorly designed
> build environment, and *that* needs fixing instead of kbuild.

Well I've never claimed that kbuild needs to be fixed.
-- 
Francis
