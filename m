Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1GaMmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 08:42:22 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53807 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab1GaMmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 08:42:16 -0400
Subject: Re: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can
 lead to double free
From: Andy Walls <awalls@md.metrocast.net>
To: Dan Carpenter <error27@gmail.com>, Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
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
Date: Sun, 31 Jul 2011 08:42:08 -0400
In-Reply-To: <20110729060822.GF3752@shale.localdomain>
References: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net>
	 <20110729060822.GF3752@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312116130.2271.8.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-07-31_02:2011-07-29,2011-07-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1107310067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 09:08 +0300, Dan Carpenter wrote:
> On Thu, Jul 28, 2011 at 11:49:51PM +0200, Jesper Juhl wrote:
> > If calling put_ir_rx(rx, true); in
> > drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then it
> > means that it has freed it's first argument. Subsequently jumping to
> > 'out_put_xx' will cause us to call put_ir_rx() once more since 'rx' is
> > not zero - leading to a double free.
> 
> It would be better to just remove the first call to put_ir_rx().

Jesper,

(Emails from you don't seem to make it to me, so I looked at your patch
in lkml.org archive.)

Good catch!

Although either fix will work, I do prefer Dan's suggested fix.  Could
you please implement that?

Since emails from you don't seem to make it to me, and since Dan's
suggestion is trivial to implement, I'll just ack that form of the fix
right now:

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

