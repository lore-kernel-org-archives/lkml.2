Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1HCIyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:54:17 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:46841 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1HCIyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:54:08 -0400
Message-ID: <4E390CAB.20305@ge.com>
Date: Wed, 03 Aug 2011 09:54:03 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus numbers
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>	<1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>	<4E36A4EA.30404@ge.com> <20110801143102.GA9705@becoht-mvanga>	<4E36CB29.2030907@ge.com> <20110802115434.GA25063@becoht-mvanga> <4E381043.7080501@ge.com>
In-Reply-To: <4E381043.7080501@ge.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2011 08:50:56.0003 (UTC) FILETIME=[75438D30:01CC51BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 15:57, Martyn Welch wrote:
> 
> Which part of the example udev rule I gave is a fixed identifier? It
> identifies the CDROM based on system topology, using the PCI bus numbering and
> SCSI bus numbering.
> 
> For example, for a device sitting on VME, in the A32 address space at 0x30000,
> via a PCI-VME bridge on PCI bus 2, device 0d, we could provide something like
> this:
> 
> vme-a32:30000-pci-0000:02:0d.0
> 

Hmm, thinking about it, that's not right either.

The VME bridge would be at "pci-0000:02:0d.0". In the current scheme this
would be given a bus number and we should be able to discover from sysfs which
bus numbers are used for which VME bridges. For example, as the usb buses are
enumerated:

$ ls -la /sys/bus/usb/devices/usb*
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb1 ->
../../../devices/pci0000:00/0000:00:1a.7/usb1
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb2 ->
../../../devices/pci0000:00/0000:00:1d.7/usb2
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb3 ->
../../../devices/pci0000:00/0000:00:1a.0/usb3
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb4 ->
../../../devices/pci0000:00/0000:00:1a.1/usb4
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb5 ->
../../../devices/pci0000:00/0000:00:1a.2/usb5
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb6 ->
../../../devices/pci0000:00/0000:00:1d.0/usb6
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb7 ->
../../../devices/pci0000:00/0000:00:1d.1/usb7
lrwxrwxrwx 1 root root 0 2011-08-03 09:29 /sys/bus/usb/devices/usb8 ->
../../../devices/pci0000:00/0000:00:1d.2/usb8
$

Whilst it would be nice to be able to change the bus numbering, I don't think
that passing numbers into the bridge driver at load time is the correct approach.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
