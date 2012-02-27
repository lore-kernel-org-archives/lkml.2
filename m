Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2B0VKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:10:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48129 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab2B0VKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:10:03 -0500
Message-ID: <4F4BF11E.4090000@zytor.com>
Date: Mon, 27 Feb 2012 13:09:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: linux-kernel@vger.kernel.org, Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
In-Reply-To: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 11:23 AM, Joshua C. wrote:
> I rebased this on the latest kernel-3.3-rc5 so that it can be properly applied.
> ------------------
> 
> From 36e15b8d9d491817a3bada5ef9375aabe9439d9b Mon Sep 17 00:00:00 2012
> From: Joshua Cov <joshuacov@googlemail.com>
> Date: Mon, 27 Feb 2012 20:49:18 +0100
> Subject: [PATCH] Use BIOS Keyboard variable to set Numlock
> 
> The PC BIOS does provide a NUMLOCK flag containing the desired state
> of this LED. Bit 0x417 has the current keyboard modifier state. This
> patch sets the current state according to the data in the bios and
> introduces a module parameter "numlock" which can be used to
> explicitely disable the NumLock (1 = enable, 0 = disable).
> 
> See first discussion back in 2007 at:
> http://lkml.indiana.edu/hypermail/linux/kernel/0707.1/1834.html
> 
> Signed-Off-By: Joshua Cov <joshuacov@googlemail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Bodo Eggert <7eggert@gmx.de>
> 

A better idea might be to query the status in the BIOS bootstrap code --
then non-BIOS boots can do the equivalent.  It also has the side benefit
of making people running Grub2 perhaps realize that they are f****ng
themselves over by using the "linux" command and not "linux16", because
of course policy in Grub2 is that if there is a sane way to do it, make
sure it is NOT the default.

	-hpa

