Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab1DHH7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:59:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48870 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab1DHH7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gXLpSQSYOPBZ2X8NCHDbrnRPJ1qierAgFzo8U7tVrzUTSjuqton5GA7yFl9J3juNBp
         54aNSwKkxUrRrR5JtwBwMIN/jEMzsogPU2JobpHfH7MDECo2Zh+U1p2D0mERNa8cBumO
         SWvLLfIkTRzMy9/vw6A4naG8JSg6bWxJaDIME=
MIME-Version: 1.0
In-Reply-To: <BANLkTimP-uhj7PQqgvpnedy_y9sQga99ug@mail.gmail.com>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
 <1302024458.2225.1350.camel@twins> <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
 <1302077959.2225.1378.camel@twins> <BANLkTimHwt=q4K9uMNX4kR6Q8LJhHHSysw@mail.gmail.com>
 <BANLkTimP-uhj7PQqgvpnedy_y9sQga99ug@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 8 Apr 2011 15:58:39 +0800
Message-ID: <BANLkTi=KZyi-e02Rc=agnVDOk+4=VLdZ-w@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
To: Dongdong Deng <libfetion@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 14:41, Dongdong Deng <libfetion@gmail.com> wrote:
> On Fri, Apr 8, 2011 at 1:36 PM, Hui Zhu <teawater@gmail.com> wrote:
>> On Wed, Apr 6, 2011 at 16:19, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Wed, 2011-04-06 at 13:54 +0800, Hui Zhu wrote:
>>>
>>>> This is a good question.
>>>>
>>>> The KGTP is completely different with KGDB.  It will not supply simple
>>>> gdbrsp debug interface to user.  It just supply  interface between the
>>>> kernel tracepoint(Now, just support kprobe, will add others later) and
>>>> GDB tracepoint function.
>>>>
>>>> So user can debug and trace Linux kernel with GDB without stop the
>>>> Linux Kernel (So the GDB can running on this Kernel).  It is a trace
>>>> tools and debug tools.
>>>
>>> But this isn't really an answer either. Could you extend the existing
>>> KGDB infrastructure to provide these features and thereby re-use
>>> existing infrastructure to reduce your patch size and code duplication?
>>>
>>> Jason (the KGDB maintainer) certainly thought there was much possibility
>>> there when I spoke to him yesterday.
>>>
>>> Think of it this way, wouldn't it be much better if there was one tool
>>> that could provide the combined feature set of KGDB and KGTP?
>>>
>>
>> Thanks Peter.  I think it is very good.
>>
>> Which part do you think kgtp can share with kgdb?
>
>
> The main realizing of "kgtp" was based on the sub protocol
> 'Tracepoint-Packets' of 'gdb Remote Serial Protocol'.
>
> http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoint-Packets.html#Tracepoint-Packets
>
> and kgdb have realized most of gdb remote serial protocols.
>
>
> thus the protocol 'Tracepoint-Packets' implement of kgtp could share
> with kgdb, and the breakpoint handler could follow kgdb's from kprobe,
>
> the offline gdb operate interface(an kernel inside gdbserver for gdb)
> could realize a module like "kgdbts" module implement
> (linux-2.6/drivers/misc/kgdbts.c).
>
> Thanks,
> Dongdong
>

Cool.  Wish someone can do that.

Thanks,
Hui
