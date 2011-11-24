Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1KXXxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:53:01 -0500
Received: from nm3-vm0.bullet.mail.ird.yahoo.com ([77.238.189.213]:20144 "HELO
	nm3-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755134Ab1KXXw6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:52:58 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 245867.29732.bm@omp1023.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=o46ltcBGR6WR4LM8Q+28FRbDzqCJxUuvEA1hk5A4NeGA6WQKS4GyneNly4aoP+RToUAU7A9X0eAOud08uyu6+HOsF3vm+YrHxsxE3T9aCrpNV7eVo4a1K2+bFh0WNddTG+GFOmEuo9uA9JzGcsxzbY9fgwhhxSQoGHS7D6cOLkI=;
X-YMail-OSG: 3o_NsH4VM1mGIBS8gpYB7W8BUJayAIUB3RkfsT1hv1GoF.y
 BzRbEmFTmkCyX5fmT9Uo2mYtxLSoSn1ZU6Hj2AbkzULQvq.c63Q6jVkHxIvs
 C96eQuUkqujnoclMagWzzvo7OGaHyEool_jmn.x6KXqjxmsu5Ng6Sssu_W.1
 2eAYXlxS77dFzCNG3kaV86fad6k1zL0FC8IBlatp_KEHjZHZzvxa3HWBIkY1
 DkzlwLMfjYW.lwpoWSqm311sxaB84VTPu4qQZma6b8uqS9.RgXSZipn0drXH
 rU_JQQTpRVrfUr43vB387tFG7GDKQf38LcSkJUppVmmTK2PzaYPoSyKwm9Jb
 gTbui4M2X2al6Hs4fIHBUOOtLaSWWBo0y.bQ9iHPXbxYYW8PN.cz76ZEOSyJ
 LkEhL8x4NW4_04g11kAYp3b9YsHiE86pJ6j4kJh38_Zc.
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.325013
Message-ID: <1322178776.45812.YahooMailClassic@web29011.mail.ird.yahoo.com>
Date: Thu, 24 Nov 2011 23:52:56 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH] power/ds2760_battery: Add rated capacity of the hx4700 3600mAh battery
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, mad_soft@inbox.ru,
        koen@dominion.thruhere.net, cbouatmailru@gmail.com
In-Reply-To: <CA+gwMcf9xvcFNJoxmDO0z-FMhKrd=9eptSDrpsBB3a20pzMfKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 24/11/11, Philipp Zabel <philipp.zabel@gmail.com> wrote:
> > +#ifdef CONFIG_MACH_H4700
> > +       0,
> > +       3600,   /* HP iPAQ hx4700 3.7V 3600mAh
> (359114-001) */
> > +#endif
> 
> Is that #ifdef needed? I know there's another one a few
> lines up, but
> I think that one is already unfortunate and there is no
> conflict here.

Yes it is needed, because the rated_capacities[] table must contain different values for different platforms. The #ifdefs preserve the original table for other platforms.

Agreed it's untidy. Ideally the table would be replaced by platform specific data. However it's not obvious which other platforms use the table, nor whether the original table is correct for those other platforms. I presume that the table was originally believed to be common for all ds2760 based platforms, but the hx4700 demonstrates this is not the case.
