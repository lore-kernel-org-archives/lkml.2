Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0H0XIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:08:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47495 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0H0XIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:08:04 -0400
Message-ID: <4C784544.2010305@zytor.com>
Date: Fri, 27 Aug 2010 16:07:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Natale Vinto <ebballon@gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com> <4C780888.9000301@zytor.com> <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com> <4C7824F2.1050709@mandriva.org> <AANLkTinjHK-oTmt-6cmN16jWWv9ZjW44wA-A3VTLm+A_@mail.gmail.com>
In-Reply-To: <AANLkTinjHK-oTmt-6cmN16jWWv9ZjW44wA-A3VTLm+A_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 02:32 PM, Matteo Croce wrote:
> can I ignore the return value when I expect val to be non zero?
> the doc says: "On error, the variable @x is set to zero."

No.  You need to deliver a page fault to the application in this case.

The *real* test for this kind of crap is correct page fault behavior,
and so forth.

Also, at the very least you need to check for:

- CS == USER_CS
- IP in the proper range for user space

Your patch in its current form is one big security hole.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

