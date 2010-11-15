Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0KOJ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:28:11 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:41864 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab0KOJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:28:09 -0500
X-ASG-Debug-ID: 1289813288-6b65c0120001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE0FD24.4030000@fusionio.com>
Date: Mon, 15 Nov 2010 10:28:04 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI TMF processing; tag allocation
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <20101113123750.GF18258@parisc-linux.org>
X-ASG-Orig-Subj: Re: SCSI TMF processing; tag allocation
In-Reply-To: <20101113123750.GF18258@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289813288
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4894 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46683
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Third, and most importantly, tags should form an increasing sequence and should not be reused until all other tags after it and before it have been reused. This for example can be accomplished if one were to use
>> find_next_zero_bit() with non-zero "offset", it being the last allocated
>> tag in a modulo the number of tags manner. That is, find_next_zero_bit()
>> could wrap as well as starting from an offset or the caller could implement
>> that via two calls to this function, in blk_queue_start_tag().

Care to explain your reasoning? For starvation issues? At least I'm not
aware of any correctness issues in that regard, but doing tag cycling in
this fashion seems like a good idea just to prevent starvation alone by
an ill behaving device.

-- 
Jens Axboe

