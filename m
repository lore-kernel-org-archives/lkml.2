Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1AHMre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 07:47:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36204 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1AHMrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 07:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lcEm7M8cPMgLRczStJs3yLgN1yV+i/2Hu0nBhCqcIerICoVbbz8UtlEGwWrr5oSLh+
         niOA6eaaJ1LmNLYQnbsXwQIYa2ot9n8O/jD43R3ShgbvgpT3d/rUDdEvTd21jED/9j5t
         1MsbhUTeBBRaFi/Py0Es6bjPgk1BDE6gWrl/I=
MIME-Version: 1.0
In-Reply-To: <20110107232339.GS21922@thunk.org>
References: <201101052237.36735.toralf.foerster@gmx.de>
	<alpine.DEB.2.00.1101071443280.23858@chino.kir.corp.google.com>
	<20110107232339.GS21922@thunk.org>
Date: Sat, 8 Jan 2011 12:47:32 +0000
X-Google-Sender-Auth: DNTYlurDAF6CY1bUhx_unVH1mNo
Message-ID: <AANLkTi=JNOF43ue6CjODXhLTMxmrRTx-7JPdYGvn60mk@mail.gmail.com>
Subject: Re: mke2fs: page allocation failure w/ kernel 2.6.37
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Ted Ts'o" <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 7 January 2011, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Jan 07, 2011 at 02:45:30PM -0800, David Rientjes wrote:
>> On Wed, 5 Jan 2011, Toralf Förster wrote:
>>
>> > Hello,
>> >
>> > I got this in /var/log/messages today (created a ext2 partition at an external USB drive, worked fine) :
>> >
>>
>> Yeah, this failure is from the kmemleak stack which simply means that
>> debugging tool will be disabled rather than any disruption to the
>> workflow.
>>
>> I'm curious why kmemleak is masking with GFP_KERNEL and GFP_ATOMIC and not
>> allowing users to pass __GFP_NOWARN to suppress this type of failure,
>> especially since the stack trace is already emitted by kmemleak when it is
>> stopped.  Catalin?
>
> Indeed, is there a reason why the kmemleak code is so noisy?  And can
> it display a more obvious message about what is going on?  It took me
> a while to figure out why it was unhappy, and whether there it was a
> fault of the code it was testing, or just that it could get the memory
> it needed....

Good point, I think kmemleak can always pass __GFP_NOWARN for its own
allocations. Note that these allocations are only for the kmemleak
metadata, the other users just allocate memory with the flags they
requested. When failing, it could also avoid printing call traces
(maybe keep a debug macro in case one wants to track this).

I'll post a patch on Monday.

Thanks.


-- 
Catalin
