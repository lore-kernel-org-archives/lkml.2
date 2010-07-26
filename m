Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0GZNWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:22:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0GZNWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:22:49 -0400
Message-ID: <4C4D8C25.8040704@redhat.com>
Date: Mon, 26 Jul 2010 15:22:45 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Nils Radtke <lkml@Think-Future.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cryptsetup + lvm on usb disk, unusable /dev/dm-* after suspend/resume
  cycle
References: <20100725160641.GK31966@localhost> <4C4CA601.6020201@redhat.com> <20100726130605.GL31966@localhost>
In-Reply-To: <20100726130605.GL31966@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 03:06 PM, Nils Radtke wrote:
> That's what I tried and failed gloriously. I'm trying to revive my memory about the 
> situation: fs could be unmounted, however, the cryptsetup luksClose failed (IRC) and 
> therefore the dmsetup remove consequently failed also.

So instead of "cryptsetup luksClose" use dmsetup remove for crypt device too
(There was a bug in some version of cryptsetup which failed close if underlying device
disappeared, should be fixed in >=1.1.2, anyway "dmsetup remove" is low-level equivalent.)

Also see man page and "dmsetup remove -f" flag.

The usb device reinitialization is separate problem, maybe someone can help if you provide
more logs.

Milan
