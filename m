Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1JPRpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 13:45:00 -0400
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:63993 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1JPRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 13:44:59 -0400
Message-ID: <4E9B182A.3020101@calvaedi.com>
Date: Sun, 16 Oct 2011 19:45:14 +0200
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
        Stelian Pop <stelian@popies.net>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
References: <4E9ABBF6.3000504@calvaedi.com> <4E9ADBD3.4070404@calvaedi.com>
In-Reply-To: <4E9ADBD3.4070404@calvaedi.com>
Content-Type: multipart/mixed;
 boundary="------------010506090502040505040303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010506090502040505040303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/2011 03:27 PM, John Hughes wrote:
> On 10/16/2011 01:11 PM, John Hughes wrote:
>> Even though sony-laptop has code to handle the volume-up/volume-down 
>> keys they don't work.  Pressing volume-down gets treated as 
>> SONYPI_EVENT_PKEY_P1 and volume-up as SONYPI_EVENT_PKEY_P2.
>
> And of course this bug has already been fixed.  Was looking at an old 
> version, 2.6.32, sorry.

Must learn to check before writing.

No, the problem has not been fixed in head.

Here's a patch that makes the volume keys work for me.  Tested on 
current git

# uname -a
Linux carbon 3.1.0-rc9+ #2 SMP Sun Oct 16 19:14:15 CEST 2011 i686 GNU/Linux



--------------010506090502040505040303
Content-Type: text/x-patch;
 name="sony-vaio-tx3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sony-vaio-tx3.patch"

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index bbd182e..ff14b61 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -2065,8 +2065,8 @@ static struct sonypi_event sonypi_batteryev[] = {
 
 /* The set of possible volume events */
 static struct sonypi_event sonypi_volumeev[] = {
-	{ 0x01, SONYPI_EVENT_VOLUME_INC_PRESSED },
-	{ 0x02, SONYPI_EVENT_VOLUME_DEC_PRESSED },
+	{ 0x01, SONYPI_EVENT_VOLUME_DEC_PRESSED },
+	{ 0x02, SONYPI_EVENT_VOLUME_INC_PRESSED },
 	{ 0, 0 }
 };
 
@@ -2113,10 +2113,10 @@ static struct sonypi_eventtypes type3_events[] = {
 	{ 0x31, SONYPI_MEMORYSTICK_MASK, sonypi_memorystickev },
 	{ 0x41, SONYPI_BATTERY_MASK, sonypi_batteryev },
 	{ 0x31, SONYPI_PKEY_MASK, sonypi_pkeyev },
+	{ 0x05, SONYPI_PKEY_MASK, sonypi_volumeev },
 	{ 0x05, SONYPI_PKEY_MASK, sonypi_pkeyev },
 	{ 0x05, SONYPI_ZOOM_MASK, sonypi_zoomev },
 	{ 0x05, SONYPI_CAPTURE_MASK, sonypi_captureev },
-	{ 0x05, SONYPI_PKEY_MASK, sonypi_volumeev },
 	{ 0x05, SONYPI_PKEY_MASK, sonypi_brightnessev },
 	{ 0 },
 };

--------------010506090502040505040303--
