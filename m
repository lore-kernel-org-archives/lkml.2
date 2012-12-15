Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2LONQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 08:16:55 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:55689 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab2LONQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 08:16:53 -0500
X-ASG-Debug-ID: 1355577412-03d6a57f9b385350001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50CC7840.4090403@fusionio.com>
Date: Sat, 15 Dec 2012 14:16:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: Jack Wang <jack.wang.usish@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>, "bcrl@kvack.org" <bcrl@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
References: <1354568322-29029-1-git-send-email-koverstreet@google.com> <20121213211808.GJ25017@kernel.dk> <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com> <50CAD6D9.5070703@fusionio.com> <20121215092526.GA10411@moria.home.lan> <50CC46F8.3070600@fusionio.com> <20121215103658.GB10411@moria.home.lan>
X-ASG-Orig-Subj: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
In-Reply-To: <20121215103658.GB10411@moria.home.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355577412
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117082
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-15 11:36, Kent Overstreet wrote:
>> Knock yourself out - I already took a quick look at it, and conversion
>> should be pretty simple. It's the mtip32xx driver, it's in the kernel. I
>> would suggest getting rid of the ->async_callback() (since it's always
>> bio_endio()) since that'll make it cleaner.
> 
> Just pushed my conversion - it's untested, but it's pretty
> straightforward.

You forgot a batch_complete_init(). With that, it works. Single device
is ~1050K now, so still slower than jaio without batching (which was
~1220K).  But it's an improvement over kaio-dio, which was roughly ~930K
IOPS.

-- 
Jens Axboe

