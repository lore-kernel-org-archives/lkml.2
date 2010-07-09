Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab0GISXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:23:30 -0400
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:47211 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751576Ab0GISX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:23:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: nic enumeration
Date: Fri, 9 Jul 2010 14:23:26 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90C3CF4C5@nsmail.netscout.com>
In-Reply-To: <AANLkTik4JOoNFSoML98j8LPJhJjVpWd8om-OYMGp3s9V@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nic enumeration
Thread-Index: AcsfibSd0eFrp0D2REqkEuczR1BuaAABBx6A
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com><20100708012120.GB11419@auslistsprd01.us.dell.com><D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com><82tyo9i0n2.fsf@mid.bfk.de><D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com> <AANLkTik4JOoNFSoML98j8LPJhJjVpWd8om-OYMGp3s9V@mail.gmail.com>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: "Steve Fink" <sphink@gmail.com>
Cc: "Florian Weimer" <fweimer@bfk.de>, <linux-net@vger.kernel.org>,
       "Matt Domsch" <Matt_Domsch@dell.com>,
       "Michael Di Domenico" <mdidomenico4@gmail.com>,
       <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>
X-OriginalArrivalTime: 09 Jul 2010 18:23:27.0261 (UTC) FILETIME=[D31B0CD0:01CB1F93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Steve Fink [mailto:sphink@gmail.com]
> Sent: July 09, 2010 1:11 PM
> To: Loke, Chetan
> Cc: Florian Weimer; linux-net@vger.kernel.org; Matt Domsch; Michael Di
> Domenico; linux-kernel@vger.kernel.org; kay.sievers@vrfy.org
> Subject: Re: nic enumeration
> 
> On Fri, Jul 9, 2010 at 9:27 AM, Loke, Chetan
<Chetan.Loke@netscout.com>
> wrote:
> > Ok, no renaming, I would like a reference. And symlink just doesn't
> work
> > w/ the udevadm trigger business. We've tried that already.
> >
> > What needs to be changed in udev etc to create a soft link? Any
place
> > where I should start digging and gotchas to lookout for?
> 
> By "soft link", I assume you're talking figuratively? 

Yes, I was using it loosely. symlink == I would like 'udev' to do the
linkage w/ the network-devices and create a reference to it.


> Soft (symbolic)
> links are a filesystem concept, implemented by filesystem-specific
> logic that knows how to read a filename out of an inode and restart
> lookup. In order for something similar to work for network devices,
> somebody would have had to explicitly implement similar functionality.
> (Symlinks are a big headache and source of security holes -- access
> control, loops, pointing to nonexistent files, etc. -- so there's a
> good reason to NOT have an equivalent for network devices.)
> 

Huh? If the 'ethX' interface doesn't exist just don't create the 'link'.
So are you saying there are no security issues with udev-symlinks for
other subsystems? Why is renaming allowed on the network-interface then?
Isn't that a problem? I don't see the driver re-registering their RX/TX
queues with the new-if-name.

May be I'm overlooking at something really obvious. But how are people
managing [pv]drivers with multiple vNICs in their VMs if they need a
consistent naming scheme?


Regards
Chetan Loke


