Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1EWTRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:17:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41717 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1EWTRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HVejH6jryFf7ZZs/L8Mfuv+riotH5AfipwB9d/XyWE5on3k/968twnDUe87PsOm29C
         RNfacVPbo6G3lDX2bhnHCd3A6IYl/pXiI+e2ZbdSMTrhQwSNkuL+jk1if9iWfUf+FXfL
         sH7TzEouRS1YO4J++Sf0CkXph2Ayi5eltUpXs=
MIME-Version: 1.0
In-Reply-To: <201105211054.00553.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<1305907896.1465.27.camel@gandalf.stny.rr.com>
	<201105210053.51314.toralf.foerster@gmx.de>
	<201105211054.00553.toralf.foerster@gmx.de>
Date: Mon, 23 May 2011 21:17:31 +0200
Message-ID: <BANLkTikQozc+rr9Meihft_avOJf=iMAGdw@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/21 Toralf Förster <toralf.foerster@gmx.de>:
>
> Toralf Förster wrote at 00:53:50
>> Bisecting gave :
>>
>>
>> git bisect badd123375425d7df4b6081a631fc1203fceafa59b2 is the first bad
>> commit commit d123375425d7df4b6081a631fc1203fceafa59b2
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Wed Jan 26 21:32:01 2011 +0100
>>
>>     rwsem: Remove redundant asmregparm annotation
>>
>>     Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
>>     compiling the kernel already with -mregparm=3. So the annotation of
>>     the rwsem functions is redundant. Remove it.
>
> BTW I double checked that this commit is the culprit of the hang - it is.
> Furthermore I added these kernel config options :

Toralf,

does this patch fix your problem?
http://userweb.kernel.org/~rw/rwsem.diff

Please do a make clean before rebuilding...

-- 
Thanks,
//richard
