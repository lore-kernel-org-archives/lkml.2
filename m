Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab2EWPGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:06:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51778 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932653Ab2EWPG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:06:29 -0400
Date: Wed, 23 May 2012 11:06:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
 =?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
In-Reply-To: <CACVXFVOUmFvEoADMQoc1S4vcW80v1efNvX=eHJheQTZzkcV9gA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205231104540.1566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Ming Lei wrote:

> >> Do you think that a buggy driver should be able to prevent the system
> >> from shutting down?
> 
> IMO, the buggy driver should be fixed first, not only in .probe or .release, but
> also in .runtime_resume, all may affect shutting down.
> 
> >
> > The original intent of the shutdown callback was to just the hardware
> > part of the device shutdown and not do muck with kernel data structures
> > because just the device portion should be more reliable and was all
> > that is needed.
> 
> The .shutdown callback pointer is got from device->driver, which is
> changed in probe and release path. Also runtime PM thing has been
> involved into shutting down recently, so looks not only hardware parts
> are involved now.

This is a tricky question.  Overall I think you're probably right.  

It's certainly true that holding the device lock across the shutdown
callback is the easiest and most reliable way to prevent these races.

Alan Stern

