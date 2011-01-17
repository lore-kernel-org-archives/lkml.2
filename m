Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1AQSlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:41:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54810 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1AQSlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QlsESIcyUfzmxO2h7tAC8mkgzMy3acmP6VkwN4IdVJY5crwCXVOWE21oiaVlL5HTuY
         PU97LuY+xQf336ABfjqWEQ/hEdl04Eoo5vWzQ2B17kpQmDlbpABnxAv6c17rlQPiAcHr
         XrFaXepwT6qLU+aCyGeoRqx/75itSfzhAvuDw=
MIME-Version: 1.0
In-Reply-To: <20110117065753.GD11358@cr0.nay.redhat.com>
References: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
	<20110117065753.GD11358@cr0.nay.redhat.com>
Date: Mon, 17 Jan 2011 11:34:08 -0700
Message-ID: <AANLkTinRZbZRaTDrBaEPFCLSkaeeOeJmsRhkaHeSom5F@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at ffff8800cf669000
From: xing lin <linxingnku@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 11:57 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> Isn't this what KSM does? :) Check mm/ksm.c, it uses jhash2().

Oh, it seems mm/ksm.c does do content-based sharing. I have not known
this and am interested to see the percentage of duplicated pages. If
there are more than 10% duplicated pages, then I plan to implement
content-based page sharing. Your input is really helpful to me.
Thanks.

>From the configuration file, I found KSM is enabled in my Ubuntu but I
still found many duplicated pages when I compile Linux-2.6.37.
(Freeable pages means the number of pages which are duplicated and can
be freed. Freeable and nonzeroed pages means the number of pages which
can be freed and do not contain all 0s.) make12G_??.als shows the
number of duplicated pages when Linux-2.6.37 is being compiled.

 utos@node:/boot$ grep CONFIG_KSM /boot/config-2.6.32-24-generic
CONFIG_KSM=y

utos@node:/tmp/data$ grep Freeable make*
make12G_00.als:Freeable pages: 42037 (22.29% of allocated pages)
make12G_00.als:Freeable and nonzeroed pages: 1220  (0.65% of allocated pages)
make12G_01.als:Freeable pages: 42441 (19.38% of allocated pages)
make12G_01.als:Freeable and nonzeroed pages: 1409  (0.64% of allocated pages)
make12G_02.als:Freeable pages: 42831 (17.51% of allocated pages)
make12G_02.als:Freeable and nonzeroed pages: 1524  (0.62% of allocated pages)
make12G_03.als:Freeable pages: 43182 (16.27% of allocated pages)
make12G_03.als:Freeable and nonzeroed pages: 1876  (0.71% of allocated pages)
make12G_05.als:Freeable pages: 48564 (15.41% of allocated pages)
make12G_05.als:Freeable and nonzeroed pages: 7171  (2.27% of allocated pages)
make12G_06.als:Freeable pages: 50040 (14.83% of allocated pages)
make12G_06.als:Freeable and nonzeroed pages: 8629  (2.56% of allocated pages)
make12G_07.als:Freeable pages: 50649 (14.27% of allocated pages)
make12G_07.als:Freeable and nonzeroed pages: 9170  (2.58% of allocated pages)
make12G_08.als:Freeable pages: 53225 (13.54% of allocated pages)
make12G_08.als:Freeable and nonzeroed pages: 11655  (2.97% of allocated pages)
make12G_09.als:Freeable pages: 57595 (13.54% of allocated pages)
make12G_09.als:Freeable and nonzeroed pages: 15946  (3.75% of allocated pages)
make12G_10.als:Freeable pages: 58137 (12.99% of allocated pages)
make12G_10.als:Freeable and nonzeroed pages: 16419  (3.67% of allocated pages)
make12G_11.als:Freeable pages: 58561 (12.56% of allocated pages)
make12G_11.als:Freeable and nonzeroed pages: 16810  (3.61% of allocated pages)
make12G_12.als:Freeable pages: 59325 (12.14% of allocated pages)
make12G_12.als:Freeable and nonzeroed pages: 17556  (3.59% of allocated pages)
make12G_13.als:Freeable pages: 60144 (11.85% of allocated pages)
make12G_13.als:Freeable and nonzeroed pages: 18293  (3.61% of allocated pages)
make12G_14.als:Freeable pages: 60521 (11.40% of allocated pages)
make12G_14.als:Freeable and nonzeroed pages: 18661  (3.51% of allocated pages)
make12G_15.als:Freeable pages: 61205 (11.07% of allocated pages)
make12G_15.als:Freeable and nonzeroed pages: 19223  (3.48% of allocated pages)
make12G_16.als:Freeable pages: 61906 (10.86% of allocated pages)
make12G_16.als:Freeable and nonzeroed pages: 19961  (3.50% of allocated pages)
make12G_17.als:Freeable pages: 62701 (10.49% of allocated pages)
make12G_17.als:Freeable and nonzeroed pages: 20537  (3.44% of allocated pages)
make12G_18.als:Freeable pages: 63207 (10.21% of allocated pages)
make12G_18.als:Freeable and nonzeroed pages: 20978  (3.39% of allocated pages)
make12G_19.als:Freeable pages: 63689 (9.94% of allocated pages)
make12G_19.als:Freeable and nonzeroed pages: 21522  (3.36% of allocated pages)
make12G_20.als:Freeable pages: 65469 (9.91% of allocated pages)
make12G_20.als:Freeable and nonzeroed pages: 23098  (3.50% of allocated pages)
make12G_21.als:Freeable pages: 65979 (9.67% of allocated pages)
make12G_21.als:Freeable and nonzeroed pages: 23554  (3.45% of allocated pages)
make12G_22.als:Freeable pages: 66527 (9.40% of allocated pages)
make12G_22.als:Freeable and nonzeroed pages: 23997  (3.39% of allocated pages)
make12G_23.als:Freeable pages: 66887 (9.14% of allocated pages)
make12G_23.als:Freeable and nonzeroed pages: 24326  (3.33% of allocated pages)
make12G_24.als:Freeable pages: 67329 (8.85% of allocated pages)
make12G_24.als:Freeable and nonzeroed pages: 24678  (3.25% of allocated pages)
make12G_25.als:Freeable pages: 68351 (8.82% of allocated pages)
make12G_25.als:Freeable and nonzeroed pages: 25537  (3.30% of allocated pages)
make12G_26.als:Freeable pages: 68913 (8.57% of allocated pages)
make12G_26.als:Freeable and nonzeroed pages: 26067  (3.24% of allocated pages)
make12G_27.als:Freeable pages: 69400 (8.44% of allocated pages)
make12G_27.als:Freeable and nonzeroed pages: 26426  (3.21% of allocated pages)
make12G_28.als:Freeable pages: 70063 (8.25% of allocated pages)
make12G_28.als:Freeable and nonzeroed pages: 27007  (3.18% of allocated pages)
make12G_29.als:Freeable pages: 71409 (8.11% of allocated pages)
make12G_29.als:Freeable and nonzeroed pages: 28383  (3.22% of allocated pages)
make12G_30.als:Freeable pages: 72235 (8.01% of allocated pages)
make12G_30.als:Freeable and nonzeroed pages: 29074  (3.23% of allocated pages)
make12G_31.als:Freeable pages: 73271 (7.70% of allocated pages)
make12G_31.als:Freeable and nonzeroed pages: 29872  (3.14% of allocated pages)
make12G_32.als:Freeable pages: 73799 (7.54% of allocated pages)
make12G_32.als:Freeable and nonzeroed pages: 30314  (3.10% of allocated pages)
make12G_33.als:Freeable pages: 74712 (7.41% of allocated pages)
make12G_33.als:Freeable and nonzeroed pages: 31019  (3.08% of allocated pages)
make12G_34.als:Freeable pages: 75264 (7.27% of allocated pages)
make12G_34.als:Freeable and nonzeroed pages: 31459  (3.04% of allocated pages)
make12G_35.als:Freeable pages: 75883 (7.15% of allocated pages)
make12G_35.als:Freeable and nonzeroed pages: 31934  (3.01% of allocated pages)
make12G_36.als:Freeable pages: 76961 (7.07% of allocated pages)
make12G_36.als:Freeable and nonzeroed pages: 32928  (3.03% of allocated pages)
make12G_37.als:Freeable pages: 77797 (6.96% of allocated pages)
make12G_37.als:Freeable and nonzeroed pages: 33726  (3.02% of allocated pages)
make12G_38.als:Freeable pages: 78814 (6.85% of allocated pages)
make12G_38.als:Freeable and nonzeroed pages: 34557  (3.00% of allocated pages)
make12G_39.als:Freeable pages: 139392 (10.02% of allocated pages)
make12G_39.als:Freeable and nonzeroed pages: 91904  (6.60% of allocated pages)
make12G_40.als:Freeable pages: 145535 (9.78% of allocated pages)
make12G_40.als:Freeable and nonzeroed pages: 97907  (6.58% of allocated pages)
make12G_41.als:Freeable pages: 152047 (9.26% of allocated pages)
make12G_41.als:Freeable and nonzeroed pages: 104118  (6.34% of allocated pages)
make12G_42.als:Freeable pages: 157866 (8.90% of allocated pages)
make12G_42.als:Freeable and nonzeroed pages: 109994  (6.20% of allocated pages)


-- 
Regards,
Xing
School of Computing, University of Utah
http://www.cs.utah.edu/~xinglin/
