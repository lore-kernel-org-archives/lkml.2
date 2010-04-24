Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0DXOhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 10:37:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54440 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752276Ab0DXOg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 10:36:59 -0400
Date: Sat, 24 Apr 2010 10:36:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       <linux-input@vger.kernel.org>, Sven Neumann <s.neumann@raumfeld.com>,
       <linux-kernel@vger.kernel.org>, Henrik Rydberg <rydberg@euromail.se>,
       Jiri Kosina <jkosina@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       Tero Saarni <tero.saarni@gmail.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 8/9] Input: Block suspend while event queue
 is not empty.
In-Reply-To: <z2wd6200be21004232202me5d59908y25bf9523fd62edce@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004241035260.6848-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Arve Hjønnevåg wrote:

> On Fri, Apr 23, 2010 at 2:08 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Friday 23 April 2010 01:56:25 pm Randy Dunlap wrote:
> >> On Thu, 22 Apr 2010 18:08:57 -0700 Arve Hjønnevåg wrote:
> >> > Add an ioctl, EVIOCSSUSPENDBLOCK, to enable a suspend_blocker that will
> >> > block suspend while the event queue is not empty. This allows userspace
> >> > code to process input events while the device appears to be asleep.
> >>
> >> All new ioctls need to be added to Documentation/ioctl/ioctl-number.txt,
> >> please.
> >
> > I do not see the reason for it to be in the kernel still. Have a process
> > that listens to all input devices (or subset of them), once events stop
> > coming initiate suspend.
> >
> 
> I think the document added by the first patch explains this. The
> solution you propose above will ignore a wakeup key pressed right
> after user space decides to initiate suspend.

Is there some reason why this feature needs to be enabled by an 
ioctl?  Why not make this suspend blocker permanently enabled?

Alan Stern

