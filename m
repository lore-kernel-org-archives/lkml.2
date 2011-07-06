Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1GFO6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:58:50 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7403 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1GFO6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:58:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for CNS3xxx hardware
Date: Wed, 6 Jul 2011 07:54:49 -0700
Message-ID: <6D7FCE1DF69D524D850E799960F2705811271D@caexch01.caveonetworks.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for CNS3xxx hardware
Thread-Index: Acw70lvLpIeQYURhS2afTgUkM/+0NQAGkvct
References: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com> <20110705140559.GA15771@oksana.dev.rtsoft.ru> <281B1F8BAB4D4BDABE7568809A0AEC1A@starsemi.com> <20110706111616.GA18967@oksana.dev.rtsoft.ru> <20110706112830.GA23184@oksana.dev.rtsoft.ru> <20110706114629.GA32659@oksana.dev.rtsoft.ru>
From: "Lin, Tommy" <Tommy.Lin@caviumnetworks.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
Cc: "Tommy Lin" <tommy.lin.1101@gmail.com>, "Wim Van Sebroeck" <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Lin, Mac" <Mac.Lin@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am thinking that mpcore_wdt should work even SMP is not turned on. Did the dependency 
is neccesarry between mpcore_wdt and SMP? If CPU1 is turned off the mpcore_wdt worked
well with CPU0 only.

Best regards,
Tommy



-----Original Message-----
From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
Sent: 7/6/2011 [星期三] 7:46 下午
To: Lin, Tommy
Cc: 'Tommy Lin'; 'Wim Van Sebroeck'; linux-watchdog@vger.kernel.org; linux-kernel@vger.kernel.org; Lin, Mac
Subject: Re: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for CNS3xxx hardware
 
On Wed, Jul 06, 2011 at 03:28:30PM +0400, Anton Vorontsov wrote:
> On Wed, Jul 06, 2011 at 03:16:16PM +0400, Anton Vorontsov wrote:
> > On Wed, Jul 06, 2011 at 06:05:37PM +0800, Tommy Lin wrote:
> > > Hi, I just found another patch that can solve the watchdog counter reload
> > > issue. Please ignore this patch, since it should not acceptable to use
> > > #ifdefs.
> > 
> > OK, great. Do I understand correctly that without Vitaly's patch,
> > your first patch is somewhat useless, as the watchdog will not work
> > or will work incorrectly? So should I postpone merging patch 1/2
> > until Vitaly's patch hit mainline?
> 
> Oh, I see that the issue isn't major, so I'll just merge the first
> patch.

Heh. Nope. It doesn't work without SMP:

warning: (ARCH_CNS3XXX) selects HAVE_ARM_TWD which has unmet direct dependencies (SMP)

And SMP support is not in the mainline, yet.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

