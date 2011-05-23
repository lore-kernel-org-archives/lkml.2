Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab1EWXii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:38:38 -0400
Received: from science.horizon.com ([71.41.210.146]:44794 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753700Ab1EWXig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:38:36 -0400
Date: 23 May 2011 19:38:35 -0400
Message-ID: <20110523233835.32254.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: arend@broadcom.com, linux@horizon.com
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
Cc: johannes@sipsolutions.net, linux-kernel@vger.kernel.org
In-Reply-To: <4DDAC1A5.20004@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Thanks. However, your code example is confusing.

>>> You can fill in a CRC table for an arbitrary polynomial with
>>>
>>> #define POLY 0xAB	/* 1 + x^2 + x^4 + x^6 + x^7 (+ x^8) */
>>> typedef uint8_t crc_type;	/* Must be an unsigned type */
>>>
>>> void
>>> crc_le(crc_type const table[256], crc_type crc, u8 const *buf, size_t len)
>>> {
>>> 	while (len--)
>>> 		crc = (crc>>  8) ^ table[(crc ^ *buf++)&  0xff];
> 
>> Here is where my confusion starts. Shifting crc by 8 bits basically 
>> means 0 ^ table[], right?

> I think I understand the code a bit better. Your code is generic for any 
> given crc_type.

Yes, exactly.  The crc_type has to be at least as wide as the CRC
being computed.  If the crc_type is only 8 bits, the shift by 8 does
indeed get optimized away.
