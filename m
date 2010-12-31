Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0LaLaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 06:30:25 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:40569 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab0LaLaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 06:30:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
Date: Fri, 31 Dec 2010 12:30:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
References: <201012310726.31851.liplianin@netup.ru> <201012311212.19715.laurent.pinchart@ideasonboard.com> <4D1DBE2A.5080003@infradead.org>
In-Reply-To: <4D1DBE2A.5080003@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311230.51903.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Friday 31 December 2010 12:27:38 Mauro Carvalho Chehab wrote:
> Em 31-12-2010 09:12, Laurent Pinchart escreveu:
> > Hi Igor,
> > 
> > On Friday 31 December 2010 06:26:31 Igor M. Liplianin wrote:
> >> It uses STAPL files and programs Altera FPGA through JTAG.
> >> Interface to JTAG must be provided from main device module,
> >> for example through cx23885 GPIO.
> > 
> > It might be a bit late for this comment (sorry for not having noticed the
> > patch set earlier), but...
> > 
> > Do we really need a complete JTAG implementation in the kernel ? Wouldn't
> > it better to handle this in userspace with a tiny kernel driver to
> > access the JTAG signals ?
> 
> Laurent,
> 
> Igor already explained it. From what I understood, the device he is
> working has a firmware that needs to be loaded via JTAG/FPGA.

I understand this. However, a complete JTAG state machine in the kernel, plus 
an Altera firmware parser, seems to be a lot of code that could live in 
userspace.

> Actually, I liked the idea, as the FPGA programming driver could be
> useful if other drivers have similar usecases.

If I understand it correctly the driver assumes the firmware is in an Altera 
proprietary format. If we really want JTAG code in the kernel we should at 
least split the file parser and the TAP access code.

-- 
Regards,

Laurent Pinchart
