Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2A2NOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 08:14:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40971 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2A2NOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 08:14:09 -0500
Message-ID: <1327842831.2718.2.camel@edumazet-laptop>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Date: Sun, 29 Jan 2012 14:13:51 +0100
In-Reply-To: <20120129111645.GA5839@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	 <20120128125108.GA9661@localhost> <1327757611.7199.6.camel@edumazet-laptop>
	 <20120129055917.GB8513@localhost>
	 <1327831380.14602.6.camel@edumazet-laptop>
	 <20120129111645.GA5839@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 29 janvier 2012 à 19:16 +0800, Wu Fengguang a écrit :


> Note that as long as buffered read(2) is used, it makes almost no
> difference (well, at least for now) to do "dd bs=128k" or "dd bs=2MB":
> the 128kb readahead size will be used underneath to submit read IO.
> 

Hmm...

# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=128k count=32768
32768+0 enregistrements lus
32768+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 20,7718 s, 207 MB/s


# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=2M count=2048
2048+0 enregistrements lus
2048+0 enregistrements écrits
4294967296 octets (4,3 GB) copiés, 27,7824 s, 155 MB/s



