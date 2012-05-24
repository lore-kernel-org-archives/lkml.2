Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2EXCOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:14:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50567 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2EXCOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:14:47 -0400
Date: Wed, 23 May 2012 19:14:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Subject: Re: Race condition between =?utf-8?Q?drive?=
 =?utf-8?Q?r=5Fprobe=5Fdevice_and_device=5Fshutdown=E2=80=8F?=
Message-ID: <20120524021429.GB12557@kroah.com>
References: <CACVXFVOUmFvEoADMQoc1S4vcW80v1efNvX=eHJheQTZzkcV9gA@mail.gmail.com>
 <Pine.LNX.4.44L0.1205231104540.1566-100000@iolanthe.rowland.org>
 <CACVXFVMqWyT78h53WnLuMYuhfFK-sbGMkS+T8SjWad6kQVFGTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVMqWyT78h53WnLuMYuhfFK-sbGMkS+T8SjWad6kQVFGTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:39:46AM +0800, Ming Lei wrote:
> On Wed, May 23, 2012 at 11:06 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 23 May 2012, Ming Lei wrote:
> >> The .shutdown callback pointer is got from device->driver, which is
> >> changed in probe and release path. Also runtime PM thing has been
> >> involved into shutting down recently, so looks not only hardware parts
> >> are involved now.
> >
> > This is a tricky question.  Overall I think you're probably right.
> >
> > It's certainly true that holding the device lock across the shutdown
> > callback is the easiest and most reliable way to prevent these races.
> 
> But holding device lock across .shutdown is very inefficient because
> most of devices' driver have not shutdown callback, so I think it is better
> to fix the race by prevent driver core from probing or releasing once
> shutdown is started.
> 
> How about the below patch?

How about waiting for the original poster to respond as to exactly how
they are hitting this race before doing anything?

greg k-h
