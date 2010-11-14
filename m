Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0KNVIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:08:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab0KNVIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:08:01 -0500
Date: Sun, 14 Nov 2010 14:08:37 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
Message-ID: <20101114140837.4bad773d@lembas.zaitcev.lan>
In-Reply-To: <4CE0458E.9070900@freemail.hu>
References: <4CD8ECE4.1090206@freemail.hu>
	<20101109075056.59a2e7d8@lembas.zaitcev.lan>
	<4CD9A96D.1010306@freemail.hu>
	<4CDF0DF4.4020405@freemail.hu>
	<20101114124035.6a0c9b80@lembas.zaitcev.lan>
	<4CE0458E.9070900@freemail.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010 21:24:46 +0100
Németh Márton <nm127@freemail.hu> wrote:

> >> (a) the transfered size equals to 800+800+800+800+800+170=4170 bytes, so the
> >> iso desc 0...4 are fully transfered and the useful data from  isodesc 5 
> >>
> >> (b) the transfered size equals to 800+800+800+800+800+800=4800 bytes, so the
> >> iso desc 0...5 are fully transfered
> >>
> >> (c) the transfered size equals to maximum possible size always, in this case
> >> 24*800=19200 bytes
> > 
> > I see you went for (a). I leaned towards (c), just for simplicity.
> 
> The (c) solution would work also, it has the drawback that in that way
> the kernel gives away the most uninitialized buffer content. Normally
> it only contains remaining bytes from the previous URB data and not
> leaking out any sensitive information.

I do not think the leakage in this case is a particular concern,
because any program that can do mmap() can scan the whole buffer.
The reported offsets are purely advisory. Moreover, the program
that merely reads can read your keyboard input. Therefore, leaking
a bit more is no worse than before. Access to usbmon must always be
protected by permissions in /dev.

-- Pete
