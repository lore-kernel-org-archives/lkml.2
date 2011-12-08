Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1LHXgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:36:55 -0500
Received: from lo.gmane.org ([80.91.229.12]:37324 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1LHXgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:36:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kristoff Bonne <kristoff.bonne@skypro.be>
Subject: serial port (DCE mode)
Date: Fri, 09 Dec 2011 00:36:33 +0100
Message-ID: <jbrhm1$i0m$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 91.181.29.139
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have a problem with serial ports, both on a friendlyarm mini2440
(running the default linux distro) and on a pandaboard running ubuntu.

Perhaps somebody can explain if the issue I have is related to these
particular boards or something generic in the linux kernel.


I want to use these boards as a ham (radio amateur) digital voice modem
and therefor I need a way to tell the radio to start transmitting.
There are a number of ways to do this, but the most used system uses the
DSR or RTS pings of the serial port (ping 4 on a DB9) (which drives a
transistor that drives the PTT signal of the radio).


Sofar so good. Just use tiocmset to control these pins. Using this on a
PC works great.



However, on these boards, the DB9 serial port is wired as "DCE" (modem),
not as "DTE" (terminal). The reason is to be able to connect a PC to
that board with a simple straight cable.
So, the "out" pins are now not DTR (4) and RTS (7) (as on a PC), but DSR
(6) and CTS (8).

Here is my problem:
-> I can use the "tiocmset" system-call to set the DSR and CTS pins; but
-althou the system call itself returns a "success"- it has no effect.
Reading the status of the pins afterwards indicate shows that their
value have not changed.

-> I can use tiocmset to set the status of the DTR and RTS pins. Reading
the values afterwards do indicate that they have flipped.

However, as these pins are "in" on the DB9 interface of these these
boards; there is nothing I can do with them.



So, here is my question:
Is there something I need to do to tell the kernel that a certain serial
port is "DCE" and not "DTE" and that thereby, the direction of DTR, RTS,
DSR and CTS have switched.


Is this a generic linux kernel issue or something specific to these boards?




Many thanks in advance,
Cheerio! Kr. Bonne.

