Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab2AMWmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:42:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56065 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2AMWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:42:14 -0500
Date: Fri, 13 Jan 2012 22:42:11 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: Handling special keys in platform drivers
Message-ID: <20120113224211.GB29022@srcf.ucam.org>
References: <CAHR064jAJkQCd_Tsrx7NHe_RbaBbNcX4sMwy=zkZCZNUNo=fAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064jAJkQCd_Tsrx7NHe_RbaBbNcX4sMwy=zkZCZNUNo=fAw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 07:24:14AM +0100, Corentin Chary wrote:

> The real problem is that for keyboard backlight to work, it needs DE
> cooperation, and only gnome as implemented that right now, and other
> (except KDE) will probably neither have the resources to handle all
> the possible keys correctly. And of course, who should handle the keys
> when there is no DE running at all ?

The problem with handling this in kernel is that there isn't an 
obviously correct policy. ACPI will typically only expose 16 or so 
backlight levels so the behaviour is easy enough, but (depending on how 
the hardware is wired up) i915 may expose around 20,000. Further, one 
machine may expose different backlight controls for different displays, 
and in that situation you need to know which one the input event is 
expected to correspond to.

Doing backlight control properly involves a lot of policy work, and I'm 
reluctant to argue that that ought to be in the kernel.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
