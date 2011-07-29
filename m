Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1G2KDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:03:50 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36868 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685Ab1G2KDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:03:48 -0400
References: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net> <20110729060822.GF3752@shale.localdomain>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110729060822.GF3752@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can lead to double free
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 29 Jul 2011 06:03:10 -0400
To: Dan Carpenter <error27@gmail.com>, Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jarod Wilson <jarod@redhat.com>,
        Jerome Brock <jbrock@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gerd Knorr <kraxel@goldbach.in-berlin.de>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Reitmayr <treitmayr@yahoo.com>,
        Michal Kochanowicz <mkochano@pld.org.pl>,
        Christoph Bartelmus <lirc@bartelmus.de>, Mark Weaver <mark@npsl.co.uk>,
        Ulrich Mueller <ulrich.mueller42@web.de>,
        Stefan Jahn <stefan@lkcc.org>
Message-ID: <f6f0d669-39e8-4435-839d-9c5525cbd8e9@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-07-28_06:2011-07-29,2011-07-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1107280229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

>On Thu, Jul 28, 2011 at 11:49:51PM +0200, Jesper Juhl wrote:
>> If calling put_ir_rx(rx, true); in
>> drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then
>it
>> means that it has freed it's first argument. Subsequently jumping to
>> 'out_put_xx' will cause us to call put_ir_rx() once more since 'rx'
>is
>> not zero - leading to a double free.
>
>It would be better to just remove the first call to put_ir_rx().
>
>regards,
>dan carpenter

Jesper,

Could you forward your original patch email to me?  I never got it.

I was the one who added all the new ref counting to lirc_zilog and it was not fun to get right (well at least what I thought was right...).

Regards,
Andy
