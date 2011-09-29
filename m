Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1I2Wvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:51:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40866 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab1I2Wvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:51:32 -0400
MIME-Version: 1.0
In-Reply-To: <18003.1317336244@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
Date: Thu, 29 Sep 2011 15:51:31 -0700
Message-ID: <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 3:44 PM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> With those 13 patches, I get this traceback. Nothing before or after
>> in logs or console.
>>
>>
>> [ 1499.098817] ------------[ cut here ]------------
>> [ 1499.108048] kernel BUG at fs/fscache/operation.c:408!
>
> Can you check what's at line 408 please?  If it's what I have in my code,
> there should be an 'assertion failed' message with some numbers before it.

Line 408 is the second half of this:

        ASSERTIFCMP(op->state != FSCACHE_OP_ST_COMPLETE,
                    op->state, ==, FSCACHE_OP_ST_CANCELLED);

Ack, you're right. I scanned right by it the first time, looking just
for traces.  Here's the bit from the logs:

[ 2709.769228] FS-Cache: Assertion failed
[ 2709.769231] 3 == 5 is false
