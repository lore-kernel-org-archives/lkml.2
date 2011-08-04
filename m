Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1HDB6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:58:34 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:61172 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab1HDB61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:58:27 -0400
X-Authority-Analysis: v=1.1 cv=8mDY8c80ZOa76EOwICuS+E2YRQjxDgO9xqUnRMONc7w= c=1 sm=0 a=869cbtyjxWwA:10 a=p8NdAnTFcCEA:10 a=8nJEP1OIZ-IA:10 a=JmtI77n5PKyEllQSDapvNg==:17 a=xe8BsctaAAAA:8 a=YNDL8i_h23cQdkTY11EA:9 a=6AmmxZOVfZb-dNgxAz0A:7 a=wPNLvfGTeEIA:10 a=JmtI77n5PKyEllQSDapvNg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 184.91.189.177
Message-ID: <4E39FCC0.4000800@cfl.rr.com>
Date: Wed, 03 Aug 2011 21:58:24 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ayan George <ayan@ayan.net>, linux-kernel@vger.kernel.org
Subject: Re: loop device auto release patch
References: <4E1F3BE0.8040506@ayan.net>	<4E209132.7000704@cfl.rr.com> <20110715121903.dc543613.akpm@linux-foundation.org>
In-Reply-To: <20110715121903.dc543613.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/15/2011 03:19 PM, Andrew Morton wrote:
> The patch appears to do two unrelated things.  That's generally frowned
> upon, but doesn't bother me much if the patch is small.
> 
> Still, splitting it into two patches (in which the bugfix is staged
> first) would be advantageous for people who might wish to backport the
> fix into earlier kernels.

It looks like this got stalled and someone emailed me asking what
happened to it.  I'm not sure that splitting the patch in two makes
sense.  I don't see how it does two unrelated things.  The uevent
problem was caused by the argument being NULL.  This patch just removes
the argument since it is entirely unnecessary.  Given that the argument
is gone and can no longer be passed as NULL, the tests for NULL are
rendered moot, and so removing them seems quite related.  I suppose you
could do the first and not the second, but then you would be leaving
cruft behind.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk45/MAACgkQJ4UciIs+XuL7+gCfUA8TpE2SRRCo+/VzRJMCrwg6
OEsAmwWphcaIF/wdguyHch6gEizv1Tjb
=pGGG
-----END PGP SIGNATURE-----
