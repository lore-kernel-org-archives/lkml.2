Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423040Ab2KNOjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:39:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423020Ab2KNOjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:39:14 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=i_vhvKUSIqUA:10 a=teNKDUfgsyCMG5Fzqe4A:9 a=PUjeQqilurYA:10 a=QT92i7zMc_8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352903952.18025.64.camel@gandalf.local.home>
Subject: Re: Possible disk failure
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Nov 2012 09:39:12 -0500
In-Reply-To: <50A326FF.6060502@gmail.com>
References: <1352865261.18025.61.camel@gandalf.local.home>
	 <50A326FF.6060502@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 23:07 -0600, Robert Hancock wrote:

> The important part being:
> 
> [   11.974811] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
> [   11.982816] ata1.00: irq_stat 0x40000008
> [   11.987512] ata1.00: failed command: READ FPDMA QUEUED
> [   11.993407] ata1.00: cmd 60/08:00:00:20:92/00:00:07:00:00/40 tag 0 
> ncq 4096 in
> [   11.993407]          res 41/40:00:04:20:92/00:00:07:00:00/40 Emask 
> 0x409 (media error) <F>
> [   12.010367] ata1.00: status: { DRDY ERR }
> [   12.015146] ata1.00: error: { UNC }
> 
> ..
> 
> [   16.527065] end_request: I/O error, dev sda, sector 127016964
> 
> i.e. the drive reported an uncorrected read error on sector 127016964.
> 

> So it looks like the drive reports there's 1 sector that will be 
> reallocated once it gets rewritten. It could be that the drive is 
> actually OK but that sector just got mis-written (due to a hard 
> power-off while it was being written, perhaps) and will be fine once it 
> gets written successfully.
> 
> You could try using hdparm commands to overwrite that sector, or just 
> boot from a live CD, zero out the entire disk with "dd if=/dev/zero 
> of=/dev/sda" and try a reinstall. If the drives go away and a long SMART 
> self test reports no errors, the drive is likely OK. If not, a 
> replacement is likely in order.
> 

Ug, I didn't want to reinstall. I've spent way too much time on setting
up this box to start over :-p

Anyway, I booted into a pxe rescue image, and performed a hdparm
--repair-sector on that bad sector, and it worked! It's back up and
running.

Thank you very much!

I'm back off to bitching about systemd and grub2 on this box ;-)

-- Steve


