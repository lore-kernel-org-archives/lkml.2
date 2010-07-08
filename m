Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab0GHL7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:59:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0GHL7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:59:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/7] block: push down BKL into .open and .release
Date: Thu, 8 Jul 2010 13:59:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-4-git-send-email-arnd@arndb.de> <4C358F29.4020505@kernel.dk>
In-Reply-To: <4C358F29.4020505@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081359.10760.arnd@arndb.de>
X-Provags-ID: V02:K0:K+/k2bqXAEK8FWHBuo9S4771FeBoHqNenjESrUNWY41
 MpxVZu6+kGfYHgPj/BMB65oCeUkv5XSwt5r+kb0Kbl9zhbquiP
 zbF5h3VqowqOvGMDcKHG6pBYvr8RLUcrES7nJduHG4FFDzhmED
 N7t7KdgcbPYyWDzCamzmaaVgsmO9QHRnwL/eQGCO/CDhYBYkEt
 0ZoGOdIjjSMcvwFcTNBcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Jens Axboe wrote:
> This is missing an smp_lock.h include in i2o as well.
> You seem to only add these sporadically, I think that
> is a bit unsafe since you are relying on unknown
> include hierarchies. That tends to break on one arch
> or config even if it works in another.

The i2o driver is the only one missing smp_lock.h, same problem
as the one you mentioned for patch 2/7. In v3 of the series it
was still correct, I broke it when I rushed out v4.

	Arnd
