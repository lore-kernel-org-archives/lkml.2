Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0H3UXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:23:20 -0400
Received: from n63.bullet.mail.sp1.yahoo.com ([98.136.44.33]:20857 "HELO
	n63.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753902Ab0H3UXT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:23:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 508595.39194.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IL+IlNRZ3KWB216VquUIznUG9o0GV/bUOR47wBYPlDqnZb08nu82EMuXUN7ua5iNJkY4LBXQBxzOKMLOHj42cYU1pOkDNZ1RhEwvxLkCqjLUwwGmjsWxDEQQDiZS3H4rG7v+deeOqXKrgTDcaFrA3KdOFFj29dt5sfyXXtGewzk=;
Message-ID: <373151.77032.qm@web180311.mail.gq1.yahoo.com>
X-YMail-OSG: uYGPhfUVM1kChld8yL74DMg1aK4kVAyRCQO77aTmdO4cxtB
 04lvkPv1X9iXm1T1BP7VZNNLL1KmjEazRYEX_duIPdgbVXMNGsz2Fza1wPLL
 eWFktf4N1FfeNUlcPF8DMMisv_tpB1m0u3gNN61ylFBczDKyV2koIlYS68oA
 kB.5134isQAi9.qGjEPuS.mIoPrucWV6wVmmWYio9AllbdnrKk9lC2v4qlME
 bPp_yRStvDgqY8OSRlckgTPeYEUVC0lFnNxObvrXmOxOnvwlkfDsO0g6y3bV
 kgHjOv31FnGa3xpW512k6_OnQtuXFL18CO_6axAQMot8yMGe7QPaCoryrgHY
 K2VZiQyGLmMhRDGxKFKGekpl5Lnc-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 30 Aug 2010 13:23:18 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4] gpio: Add driver for basic memory-mapped GPIO controllers
To: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20100829212857.GA25592@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sun, 8/29/10, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
Brownell
> wrote:
> > But  do it without BUG()... 
> Yeah, good idea. Let's turn these BUG() into
> WARN_ON_ONCE()?

I'm not a big fan of redundant -- and
 noisy! error reports like
that:  recall that errors were already reported
(and ignored) on those paths, indicating invalid
GPIOs (requested, or direction set, etc).

The read paths should probably just return zero;
that's required in some cases, if you read the
interface spec.

