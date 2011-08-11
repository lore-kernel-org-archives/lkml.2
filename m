Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1HKF0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:26:01 -0400
Received: from nm22.bullet.mail.bf1.yahoo.com ([98.139.212.181]:27832 "HELO
	nm22.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751260Ab1HKF0A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:26:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 849948.4418.bm@omp1031.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qKQAKSfRYQcQ1r9k02liwP3343sV4aXaGnczkDNZmoikz8CiW4GeACN+eWOc6JdUEeBX/m8LX4n1LTHSf5uJsqcpwHB1Ft7jRbeYd5R9A9hFTbpvF+JhY4ED65n4Z8mrfFVkPEAE6ZSkKaymPPfKRSa+HLWsr+UMYr2NQMoGWKs=;
X-YMail-OSG: RK3.SUoVM1nDmhCs4vvM0Ct1CNlOVQ_XSDQ9mLfLxpobH5H
 dQ4DkwGQtIC6rXrDtcubWdA2SNKAHex6k5Qbcbr3ZRRGB2xKJslgZHB8cGFA
 F8yxDE9IxsJODBXFkbTfKkHhopMNMqKXCgI20vPRQbQy8cRbpgdGPQ0V.q2v
 K0BOQBMxq0TCouzkHWVgKePHPzcNCVUD0gd391WEs6aIs2IZR8BZtkkgCWTC
 9kWz800S4g0irsdH5ua70OAXYkY9120x6q1lS7nuNcp6b2cJ9rqtEWzDgE3A
 PwhWbN0Bbupm3wb418819gH2pSXB2ViHSyHtoTJv39Zp4Cmk0_KnZFSOY8gK
 yiZdPyOzigfxK_wwfb8xonWZTQ2IU.Z94rzz_Xq1fJD9UaHINQP8q.91LFWT
 qmO34vY7QiuAgkSEm.L7bklhblxX7OlMQT6VBWzHGKvVLkouWxnhXsV0XLSJ
 Wtb_o3ISFjEDF03yajlSXhIt3RdIXMqHKed5f5cI8LgFxOgIf02JzU2r659K
 c7VBMzI3IwQHnZ_cEezXfc7pnKGidfUD6fkAiwBRRK3K86XE-
X-Mailer: YahooMailWebService/0.8.113.313619
References: <20110804143844.GQ19099@suse.de> <1312526302.37390.YahooMailNeo@web162009.mail.bf1.yahoo.com> <20110805080133.GS19099@suse.de>
Message-ID: <1313040359.41174.YahooMailNeo@web162012.mail.bf1.yahoo.com>
Date: Wed, 10 Aug 2011 22:25:59 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Re: MMTests 0.01
To: Mel Gorman <mgorman@suse.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110805080133.GS19099@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mel Gorman,
 
I found one problem in MMTests0.01/fraganalysis/Makefile
 
When I did "make install" here, I got the following error:
install: cannot stat `record-buddyinfo': No such file or directory
make: *** [install-script] Error 1
 
I think the following line in makefile need to be corrected:
#####INSTALL_SCRIPT = pagealloc-extfrag show-buddyinfo slab-intfrag record-buddyinfo

INSTALL_SCRIPT = pagealloc-extfrag show-buddyinfo slab-intfrag record-extfrag
 
I corrected this and it works now.
 
 
 
Thanks,
Pintu
 
 
From: Mel Gorman <mgorman@suse.de>
To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Friday, 5 August 2011 1:31 PM
Subject: Re: MMTests 0.01

On Thu, Aug 04, 2011 at 11:38:22PM -0700, Pintu Agarwal wrote:
> Dear Mel Gorman,
>  
> Thank you very much for this MMTest. 
> It will be very helpful for me for all my needs.
> I was looking forward for these kind of mm test utilities.
>  
> Just wanted to know, if any of these utilities also covers
> anti-fragmentation represent of the various page state in the form
> of jpeg image?

No, that particular script was not included as it needs a kernel patch
to be really useful and depends on parts of VM Regress that were very
ugly. As I've said before, I generally use unusable free space index
and fragmentation index if I'm trying to graph fragmentation-related
information. To record it, I use the "extfrag" monitor in monitors/
. It uses other helpers of which fraganalysis/show-buddyinfo is the
most important as it is the one that can read either /proc/buddyinfo
or use /proc/kpagefrags to build a more accurate picture.

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
