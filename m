Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab2ABDZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 22:25:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62408 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2ABDY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 22:24:58 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Mon, 2 Jan 2012 04:24:54 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oliver@neukum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <20120101203945.0ebc2f55@pyramind.ukuu.org.uk> <20120101215000.04b13f43@milhouse>
In-Reply-To: <20120101215000.04b13f43@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201020424.54444.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 1 Jan 2012 20:39:45 +0000
> 
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > When you suspend the power gets killed so the device loses its firmware
> > and goes back to being a firmware requesting thing on resume.
> > 
> > Worse still - you don't easily know if the device is in fact new and was
> > added while suspended, or was always there.
> > 
> > So for those devices you do need to load the firmware into them
> > automatically after the resume to work out what they are and get the MAC
> > to see if its the same wireless card or not.
> 
> Well, that does not prevent you from caching the firmware once you
> got it from userspace and keep it until module unload (or probably device
> close), so that it is already available on resume.

That's actually wrong. If you cached every single firmware, the kernel would 
gulp down a lot of space that can't be swapped out!

M
