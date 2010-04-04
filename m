Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0DDIia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 04:38:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34824 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0DDIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 04:38:23 -0400
To: tek-life <teklife.kernel@gmail.com>
Cc: dhazelton@enter.net, oliver@neukum.org, linux-kernel@vger.kernel.org
Subject: Re: Can we remove the Zone_DMA?
References: <m2mc58e39921004032121hc7ca41f0gacd90ffe2abc6444@mail.gmail.com>
	<k2tc58e39921004032226ze2eb64dev21f8c2d137a49ebc@mail.gmail.com>
	<s2mc58e39921004032233rfd47a83eoa86b37ffe59d2e7@mail.gmail.com>
	<201004040349.28840.dhazelton@enter.net>
	<j2rc58e39921004040128xb502c314u4b6b080a77fee813@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 04 Apr 2010 01:38:17 -0700
In-Reply-To: <j2rc58e39921004040128xb502c314u4b6b080a77fee813@mail.gmail.com> (tek-life's message of "Sun\, 4 Apr 2010 16\:28\:49 +0800")
Message-ID: <m18w93hati.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: teklife.kernel@gmail.com, linux-kernel@vger.kernel.org, oliver@neukum.org, dhazelton@enter.net
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tek-life <teklife.kernel@gmail.com> writes:

> Thanks for your replys.
> I was confused. The motherboard of  Intel i810 chipset in early 1999
> had not supported the ISA. You say keyboard should use ISA, what
> should work for the pc using the i810 motherboard. More important ,
> the keyboard don't use DMA.

Last I heard this discussed it was mentioned that there were some
fairly common integrated sound devices using ISA DMA.

As for the i810 chipset not supporting ISA that isn't really true.  No
one implements ISA plug-in slots, but at least in the for of LPC
hardware that is effectively ISA continues to be supported for various
legacy devices.

Ultimately I don't see much point in disabling ZONE_DMA.  It is a lot of
work to track down if it is really needed, and it only costs 16MB.  So
unless someone shows me that ZONE_DMA triggers the OOM killer unnecessarily
or otherwise impacts the system what does legacy code hurt?

Eric
