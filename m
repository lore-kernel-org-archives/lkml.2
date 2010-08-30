Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0H3VV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:21:58 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:32812 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab0H3VV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=TUG_nH7oNDNHBkmtGaJHgBwtC6Y-KRWrRfgD9@mail.gmail.com>
References: <AANLkTi=TUG_nH7oNDNHBkmtGaJHgBwtC6Y-KRWrRfgD9@mail.gmail.com>
Date: Mon, 30 Aug 2010 17:21:54 -0400
Message-ID: <AANLkTi=XMndNRm5awJMkY-kwF7dFXvVJ5Nk7nDfhZh68@mail.gmail.com>
Subject: Re: ssd's and iops testing
From: Nathan Wan <nlw@andrew.cmu.edu>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Nathan Wan <nlw@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, WEBMAIL_SOURCE 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HELO_GMAIL 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __RDNS_GMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a first post for me on a linux list so please forgive if I am
doing it wrong.

I'm looking for some advice about the scsi subsystem and the linux
kernel.  I am writing a module to test the capabilities of particular
i/o hardware configurations. Specifically, I am trying to bypass the
block io system to identify bottlenecks for less powerful cpu's paired
with solid state drives (e.g. an Intel Atom processor with an SSD
capable of 60K iops).

My goal is to make a module that will saturate the ncq of the drive
and see if it is possible for the cpu keep up with the drive.  I am
doing this by creating scsi commands that read random sectors off the
disk.  Essentially the module mimics the role of the block layer,
performing operations similar to the request function
(scsi_request_fn) and the sd_prep_fn, and uses the Scsi_Host,
scsi_device and scsi_target structs to insert my own scsi commands.
scsi_cmnd structs are taken from the scsi_device through
scsi_get_command and dispatched to the ahci host by the queuecommand
function.

The drives are supported by the ahci driver in libata, and are already
mounted on the machine as scsi drives (e.g. /dev/sda and /dev/sdb).

My problem now is that when I run the module, asking to issue too many
read commands can cause the kernel to hang.  I would like to run the
thread for about ten seconds (60K iops * 10 sec = 600K read requests),
but I'm not sure if it is a problem running it from the insmod
application thread, i.e. my module's init thread is issuing all the
commands.  Also, I am not sure what I need to do to ensure I am not
ruining something in the i/o hierarchy, e.g. messing up something in
the block layer, or breaking the sd or ahci driver.  Any advice would
be greatly appreciated.

Is ten seconds too long for an insmod thread to run?

I have tried to use blk_{start, stop}_queue while my thread is issuing
commands; is this appropriate?

What else can I do to see how my module changed the kernel?

Thanks in advance

Nathan

PS I'm not signed up for the list yet, so please cc me on the responses
