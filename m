Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0KVMvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:51:13 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:63158 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755793Ab0KVMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:51:10 -0500
Subject: Re: What should poll() return when a device is unregistered ? (was
 "media: Media device node support")
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com, linux-kernel@vger.kernel.org
In-Reply-To: <201011221236.40194.hverkuil@xs4all.nl>
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <201011221008.06852.hverkuil@xs4all.nl>
	 <201011221141.27945.laurent.pinchart@ideasonboard.com>
	 <201011221236.40194.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 07:51:37 -0500
Message-ID: <1290430297.2092.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-22_06:2010-11-22,2010-11-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1011220058
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 12:36 +0100, Hans Verkuil wrote:
> On Monday, November 22, 2010 11:41:27 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Monday 22 November 2010 10:08:06 Hans Verkuil wrote:
> > > On Monday, November 22, 2010 00:35:54 Laurent Pinchart wrote:
> > > > Hi Jonathan,

> > > This doesn't really seem to be standardized :-(
> > 
> > CC'ing LKML with the question.
> > 
> > POLLERR | POLLHUP and POLLERR won't make a difference to select(), but we 
> > should still standardize on a poll() return code when devices are unregistered 
> > and/or - for hot-pluggable devices - disconnected (for V4L devices 
> > unregistered usually means disconnected) ?
> 
> Drivers return POLLERR, POLLERR|POLLHUP or POLLHUP in case of a disconnect.
> I'm leaning towards POLLHUP as the most appropriate poll return value for a
> USB disconnect.

+1 POLLHUP

http://www.opengroup.org/onlinepubs/009695399/functions/poll.html

"POLLHUP
        The device has been disconnected. [...]"


My $0.02 below:
The communication link with the device is closed due to circumstances
that the OS considers normal operation.  The OS has, at some level, shut
down its side of the communication link gracefully as well.

Just because the application or the OS cannot always predict when a USB
disconnect may happen, doesn't mean it is an error.


Regards,
Andy


