Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1BPDBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:01:38 -0500
Received: from bay0-omc1-s11.bay0.hotmail.com ([65.54.190.22]:1876 "EHLO
	bay0-omc1-s11.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546Ab1BPDBf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:01:35 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 22:01:35 EST
Message-ID: <BAY144-W17A513D39A8C38BA849520BED20@phx.gbl>
X-Originating-IP: [200.161.132.95]
From: Roberto Spadim <robertospadim@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: md new raid read balance, i need help to end this new feature -
 queue block informations
Date: Wed, 16 Feb 2011 00:56:22 -0200
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Feb 2011 02:56:22.0085 (UTC) FILETIME=[179F4750:01CBCD85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi guys, i´m making a new read_balance function for md (linux software raid) can anyone help me?
i need informations about queue of each mirror (/dev/sda, /dev/nbd, /dev/hda, /dev/XXX = block devices)
what information?
estimate time to end queue commands

why? with estimate time i can select the best mirror (raid1) to read, the time with less queue time + less read time, is the best disk to read

i know there´s some elevators and some devices that don´t work with queue, or have user space queue that is dificult to get estimate value
in this case i want:
total sectors to write (sequencial/non sequencial if possible)
total sectors to read (sequencial/non sequencial if possible)
first and last sector number (to get disk position change time, i´m considering that elevator get the smallest patch, so the last-first is the head distance, head distance * distance/sector give me a good estimation value)

i think that´s all

in raid1.c i have the generic_make_request() call, can i get all informations with those parameters?

sorry i´m from brazil if i wrote something out of order, or difficult to understand please report it.
the today implementation is kernel 2.6.37 based, source at:
www.spadim.com.br/raid1/

any help is welcome
thanks
 		 	   		  