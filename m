Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1KWSF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:05:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1KWSFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <877h2r1hb3.fsf@faui43f.informatik.uni-erlangen.de>
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
	<CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
	<4EC8FF93.7010706@suse.cz>
	<20111123055351.GB14454@mail.gmail.com>
	<877h2r1hb3.fsf@faui43f.informatik.uni-erlangen.de>
Date: Wed, 23 Nov 2011 13:05:53 -0500
Message-ID: <CACqU3MXe3vu8OmcTsU4u8h+zWfOyo455Q-RLAJrADJM4xoJnPg@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Fix checking return value of 'fwrite'
From: Arnaud Lacombe <lacombar@gmail.com>
To: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
Cc: Jean Sacren <sakiwit@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de, amwang@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/11/23 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
> On Mi, Nov 23, 2011 at 06:53:51 (CET), Jean Sacren wrote:
>
>> From: Michal Marek <mmarek@suse.cz>
>> Date: Sun, 20 Nov 2011 14:24:35 +0100
>>>
>>> On 7.10.2011 05:29, Arnaud Lacombe wrote:
>>> > Hi,
>>> >
>>> > 2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
>>> >> fwrite indicates '1' written member if a zero-length string is written.
>>> > you forgot the "Signed-off-by: " part :)
>>>
>>> Reinhard, can I assume
>>>
>>> Signed-off-by: Reinhard Tartler
>>> <Reinhard.Tartler@informatik.uni-erlangen.de>
>>>
>>> ? The patch is otherwise correct.
>>
>> I have two reasons to oppose this patch.
>>
>> 1. If 'len' value is zero, there is an issue already and it should be
>> taken care of _before_ calling fwrite().
>
> So you're saying the function assumes a non-empty string? Why?
AFAIK, fwrite(3) is currently used:
 1) in comment printers. Empty comment are not allowed.
 2) in a callback passed to expr_print(), where the string printed is
non-empty[0]
 2) in the lexer, auto-generated, and unused

So Jean's point is valid, but for this comment to be pedantic, I would
not weakly test for `len > 0', but enforce assumptions above with an
assertion, by both converting the existing direct call to xfwrite()
and add `assert(len > 0)' before calling fwrite(3).

 - Arnaud

[0]: symbol's name is either NULL or a non-empty string.
