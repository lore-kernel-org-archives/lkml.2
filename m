Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1GUUxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:53:13 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4168 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab1GUUxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:53:09 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Brendan Moran" <bremoran@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jul 2011 13:52:56 -0700
Subject: gpio_set_debounce return value specification
Thread-Topic: gpio_set_debounce return value specification
Thread-Index: AcxH524hwxEop8gCSGahvpXa9i4orw==
Message-ID: <586BFDFA1320D943A83378A4BDEF65B0BF7C649BFD@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {32D4E5EC-F82F-4066-9EE9-91A461AB51CE}
x-cr-hashedpuzzle: BFMt BI5T BhO2 BmXT EE1E FTk8 FYY7 FvA0 GEDM GlLZ
 GmQg IM0X IQkK IVgx I9PU
 K0i4;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{32D4E5EC-F82F-4066-9EE9-91A461AB51CE};YgByAGUAbQBvAHIAYQBuAEAAYgByAG8AYQBkAGMAbwBtAC4AYwBvAG0A;Thu,
 21 Jul 2011 20:52:56
 GMT;ZwBwAGkAbwBfAHMAZQB0AF8AZABlAGIAbwB1AG4AYwBlACAAcgBlAHQAdQByAG4AIAB2AGEAbAB1AGUAIABzAHAAZQBjAGkAZgBpAGMAYQB0AGkAbwBuAA==
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 62364D673DK1820783-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding gpio_set_debounce, declared in include/linux/gpio.h, defined in drivers/gpio/gpiolib.c

The return value for gpio_set_debounce isn't clearly specified.  The current use of the return value appears to be 0 on success, <0 on error.  Because many hardware implementations allow only specific debounce intervals, the actual debounce setting after calling gpio_set_debounce is unlikely to be the argument with which it was called.

I suggest that on success, the return value should be a positive integer indicating, in microseconds, the actual debounce interval which has been applied.  A value of 0 would indicate that the debounce was applied successfully, but the driver does not support this reporting.

The current code in gpiolib.c would support this without change.   A documentation change to gpiolib.c and gpio.h would be necessary.

Brendan Moran

