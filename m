Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2L0XST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:18:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53259 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752383Ab2L0XSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:18:17 -0500
Date: Thu, 27 Dec 2012 18:18:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
In-Reply-To: <50DC6D5D.30806@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1212271803570.9950-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012, Larry Finger wrote:

> I could not do exactly the experiment that you wanted, as ehci-hcd was loaded 
> even though it was blacklisted. Rather than solve that problem, I generated a 
> kernel from just before commit adfa79d with ohci-hcd built in and ehci-hcd as a 
> module. This one generated the errors, but they stopped when ehci-hcd loaded. I 
> also tested a 3.8-rc1 kernel with ehci-hcd and ehcd-pci built in and ohci-hcd as 
> a module. No errors for that one. Your hypothesis looks correct.
> 
> I hope there is some way to force ehci-pci to load as soon as ehci-hcd is 
> loaded, and before ohci-hcd loads, but if there is not, I know how to prevent 
> the errors on my system even though this solution won't help the users of distro 
> kernels. At least this time the errors stop once all 3 modules are loaded, and 
> the number of error outputs is limited.

This is now a userspace issue.  Perhaps a change to a udev rule will
prevent ohci-hcd from loading until ehci-pci is in place.  Or a change
to a startup script in your initramfs.  However the problem gets
solved, there doesn't seem to be much the kernel can do about it.

Alan Stern

