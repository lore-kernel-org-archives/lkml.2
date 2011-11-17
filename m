Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1KQUuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:50:40 -0500
Received: from re04.intra2net.com ([82.165.46.26]:48257 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1KQUuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:50:39 -0500
Message-ID: <4EC5739D.9010008@intra2net.com>
Date: Thu, 17 Nov 2011 21:50:37 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: AVR32 code: Mismatching comparison
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

consider this piece of code from
arch/avr32/kernel/module.c:

....
case R_AVR32_GOT18SW:
    if ((relocation & 0xfffe0003) != 0
        && (relocation & 0xfffc0003) != 0xffff0000)
        return reloc_overflow(module, "R_AVR32_GOT18SW",
                    relocation);
    relocation >>= 2;
    /* fall through */
...

cppcheck reports for line 267:
"Mismatching comparison, the result is always true"

This probably needs a fix.

Cheers,
Thomas
