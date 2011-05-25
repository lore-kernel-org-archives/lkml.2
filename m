Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1EYFqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:46:37 -0400
Received: from science.horizon.com ([71.41.210.146]:45695 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752721Ab1EYFqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:46:36 -0400
Date: 25 May 2011 01:46:34 -0400
Message-ID: <20110525054634.5033.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: arend@broadcom.com, linux@horizon.com
Subject: Re: [RFC] lib: crc8: add new library module providing crc8 algorithm
Cc: akpm@linux-foundation.org, error27@gmail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4DDC91E1.40104@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/25/2011 12:52 AM, George Spelvin wrote:
>> May I suggest that crc8_create is A Stupid Idea.  Since the bit order
>> (and polynomial) will always be compile-time constants, just let the
>> call sites call crc8_create_[lm]sb_first() directly.

> Thanks for be subtle in your suggestion.

Since you are obviously being ironic in your phrasing, I hope I did not
give serious offense.  What I wrote is a fairly accurate description of
my reflex reaction, but I could have phrased it more diplomatically.

> If callers use the specific function they can not specify a bit order so 
> no compile-time error.

What I meant was, the bit order is specified by the function name.
An invalid bit order translates to an invalid function name, which the
linker will complain about.


If you feel ambitious, you can fold the crc7 code into yours.  Its an
msbit-first CRC.  The resultant table will be left-justified rather
than the current right-justified, but if you look at all the call sites,
you'll notice that they all shift the result left 1 bit!

I have a pending bug report about some of the calling code which I
noticed when trying to update it myself, but it doesn't actally
prevent updating the crc7() call sites:
http://marc.info/?l=linux-wireless&m=130616050311698
