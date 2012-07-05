Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2GEBU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:20:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52185 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751148Ab2GEBUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:20:24 -0400
Date: Wed, 4 Jul 2012 21:20:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frederik Himpe <fhimpe@telenet.be>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
In-Reply-To: <1341433169.4131.13.camel@piranha.localdomain>
Message-ID: <Pine.LNX.4.44L0.1207041714280.18768-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Frederik Himpe wrote:

> > That doesn't disable autosuspend.  The proper way is:
> > 
> > 	echo on >/sys/bus/usb/devices/.../power/control
> > 
> > where you fill in the "..." with the directory name for the webcam.
> 
> usb trace from trying mplayer a few times after disabling autosuspend:
> 
> ffff880415761ec0 897158138 S Ii:1:081:7 -115:128 16 <
> ffff8803c49ec800 897158252 S Co:1:081:0 s 21 01 0100 0003 001a 26 = 01000101 15160500 00000000 00000000 00000000 00000000 0000
> ffff8803c49ec800 897162252 C Co:1:081:0 -71 0

This is already too late.  The -71 error code indicates that the webcam 
has crashed.  We need to see what happens before the crash, in order to 
determine what causes it.

Did you use the right path for the webcam device?  According to your
logs, it should be 1-1.2 -- assuming you plug the webcam into the same
port as before.

Alan Stern

