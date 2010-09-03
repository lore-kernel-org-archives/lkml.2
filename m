Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab0ICJOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:14:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0ICJOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:14:07 -0400
Message-ID: <4C80BC5C.2010804@kernel.org>
Date: Fri, 03 Sep 2010 11:14:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ida: fix up bitmap size calculation
References: <1283446829-24050-1-git-send-email-namhyung@gmail.com>	<4C7FDCE4.1080703@kernel.org>	<AANLkTi=Ema3mTkU7J7XKqmntA+VDJizhBuDHHnZtV_9K@mail.gmail.com> <87vd6o9fzf.fsf@gmail.com>
In-Reply-To: <87vd6o9fzf.fsf@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 09:14:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 08:07 PM, Namhyung Kim wrote:
> Namhyung Kim <namhyung@gmail.com> writes:
>> Got it. :-) I'll prepare new patch with that comment, then.
>> Thank you for the explanation.
> 
> How about this?

I'd prefer something with a bit more brevity.  If this looks good, can
you please send it to trivial@kernel.org?

Thanks.

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e968db7..1208528 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -117,9 +117,12 @@ void idr_init(struct idr *idp);
 /*
  * IDA - IDR based id allocator, use when translation from id to
  * pointer isn't necessary.
+ *
+ * IDA_BITMAP_LONGS is calculated to be one less to accomodate
+ * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
  */
 #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
-#define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
+#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long) - 1)
 #define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)

 struct ida_bitmap {


-- 
tejun
