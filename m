Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750734Ab0KVQTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:19:32 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:40277 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0KVQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:19:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: What should poll() return when a device is unregistered ? (was "media: Media device node support")
Date: Mon, 22 Nov 2010 17:19:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        linux-media@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        linux-kernel@vger.kernel.org
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com> <201011221236.40194.hverkuil@xs4all.nl> <1290430297.2092.16.camel@morgan.silverblock.net>
In-Reply-To: <1290430297.2092.16.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011221719.38369.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Monday 22 November 2010 13:51:37 Andy Walls wrote:
> On Mon, 2010-11-22 at 12:36 +0100, Hans Verkuil wrote:
> > On Monday, November 22, 2010 11:41:27 Laurent Pinchart wrote:
> > > Hi Hans,
> > > 
> > > On Monday 22 November 2010 10:08:06 Hans Verkuil wrote:
> > > > On Monday, November 22, 2010 00:35:54 Laurent Pinchart wrote:
> > > > > Hi Jonathan,
> > > > 
> > > > This doesn't really seem to be standardized :-(
> > > 
> > > CC'ing LKML with the question.
> > > 
> > > POLLERR | POLLHUP and POLLERR won't make a difference to select(), but
> > > we should still standardize on a poll() return code when devices are
> > > unregistered and/or - for hot-pluggable devices - disconnected (for
> > > V4L devices unregistered usually means disconnected) ?
> > 
> > Drivers return POLLERR, POLLERR|POLLHUP or POLLHUP in case of a
> > disconnect. I'm leaning towards POLLHUP as the most appropriate poll
> > return value for a USB disconnect.
> 
> +1 POLLHUP
> 
> http://www.opengroup.org/onlinepubs/009695399/functions/poll.html
> 
> "POLLHUP
>         The device has been disconnected. [...]"
> 
> 
> My $0.02 below:
> The communication link with the device is closed due to circumstances
> that the OS considers normal operation.  The OS has, at some level, shut
> down its side of the communication link gracefully as well.
> 
> Just because the application or the OS cannot always predict when a USB
> disconnect may happen, doesn't mean it is an error.

POLLHUP seems to be the best option standard-wise, but it could be a problem 
for output devices. Applications use the write file descriptors set with 
select() to wait for a buffer to be ready. Unlike POLLERR, POLLHUP only 
reports an event on the read file descriptors set.

-- 
Regards,

Laurent Pinchart
