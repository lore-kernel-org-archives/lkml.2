Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1KWGeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:34:13 -0500
Received: from vamos2c.informatik.uni-erlangen.de ([131.188.42.15]:45166 "EHLO
	vamos2c.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048Ab1KWGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:34:11 -0500
From: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
To: Jean Sacren <sakiwit@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de, amwang@redhat.com
Subject: Re: [PATCH] kconfig: Fix checking return value of 'fwrite'
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteilte Systeme
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
	<CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
	<4EC8FF93.7010706@suse.cz> <20111123055351.GB14454@mail.gmail.com>
X-Url: http://www4.informatik.uni-erlangen.de/~tartler
Date: Wed, 23 Nov 2011 07:30:56 +0100
In-Reply-To: <20111123055351.GB14454@mail.gmail.com> (Jean Sacren's message of
	"Tue, 22 Nov 2011 22:53:51 -0700")
Message-ID: <877h2r1hb3.fsf@faui43f.informatik.uni-erlangen.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, Nov 23, 2011 at 06:53:51 (CET), Jean Sacren wrote:

> From: Michal Marek <mmarek@suse.cz>
> Date: Sun, 20 Nov 2011 14:24:35 +0100
>>
>> On 7.10.2011 05:29, Arnaud Lacombe wrote:
>> > Hi,
>> > 
>> > 2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
>> >> fwrite indicates '1' written member if a zero-length string is written.
>> > you forgot the "Signed-off-by: " part :)
>> 
>> Reinhard, can I assume
>> 
>> Signed-off-by: Reinhard Tartler
>> <Reinhard.Tartler@informatik.uni-erlangen.de>
>> 
>> ? The patch is otherwise correct.
>
> I have two reasons to oppose this patch.
>
> 1. If 'len' value is zero, there is an issue already and it should be
> taken care of _before_ calling fwrite().

So you're saying the function assumes a non-empty string? Why? It is a
simple "writing-helper" and this seems a perfectly valid corner case to
me.  Can you perhaps elaborate why you consider this corner case invalid
and require (possibly out-of-tree) callers to check this for themselves?

> 2. xfwrite() doesn't fix anything except for the compiler warning. It
> assumes this world is perfect and it's definitely not a place to take
> care of the zero-length string.

It seems to me that you rather oppose to the introduction of xfwrite()
than to the patch here at hand. Is that correct?

Cheers,
Reinhard

-- 
Reinhard Tartler                     Department of Computer Science IV
Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
            http://www4.informatik.uni-erlangen.de/~tartler
