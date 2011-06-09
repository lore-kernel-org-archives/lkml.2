Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1FIUUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:20:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1FIUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:20:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor management driver
Date: Thu, 9 Jun 2011 22:20:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linuxppc-dev@lists.ozlabs.org, alan@lxorguk.ukuu.org.uk,
        kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, cmetcalf@tilera.com, konrad.wilk@oracle.com,
        linux-console@vger.kernel.org
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <201106090929.23671.arnd@arndb.de> <4DF11715.5030001@freescale.com>
In-Reply-To: <4DF11715.5030001@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106092220.22246.arnd@arndb.de>
X-Provags-ID: V02:K0:pXswJsBvZ8SiegMOK/U1whUydqyW/5lvx6PODQ1paJH
 6kVSUF6wLTm07iQn/gQDQ8UuP8gXz+M3+HQLZDXfS/V6gOmmss
 5zqTDq7fSHzky9m27rIrIhtSkabekVblrrdkR8zaS+/7/R1vbX
 XvkmYUDVQFvQNBQ8VuFXzOqEbwI13VuDkrX1IxI2JlwKYkFO1c
 GuLQ9RLeLaVy+SFEWr1QA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 20:55:17 Timur Tabi wrote:
> Arnd Bergmann wrote:
> > Then get rid of all the code that takes apart the ioctl command numbers
> > again and just do a switch/case based on the command.
> 
> I still need to keep that code to maintain binary compatibility with existing
> applications that pass the union as a parameter.
> 
> I'll fix that after we've updated the applications.  But we have a
> chicken-or-the-egg problem where we need the same application to work with the
> new and old ioctl interface for a period of time.

The lesson to learn here is obviously not to ship binaries of applications
to customers before the driver has been merged in a mainline kernel.

The best way out that I can see is to make the driver carry the proper
interface in the upstream version, but to have a private patch to support
both interface versions in the kernel you ship on machines that require
backwards compatibility. Once you have phased out the user application,
you can then drop that patch and use the upstream version of the
interfaces.

	Arnd
