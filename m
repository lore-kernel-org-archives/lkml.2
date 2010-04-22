Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0DVX2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:28:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42631 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0DVX2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <ED2979D1CA1B3E4BB166ED9990088522765E30@SJOAMSEXB01.AMERICAS.ROOT.PRI>
References: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI>
	 <20100421182747.GB7876@kroah.com>
	 <ED2979D1CA1B3E4BB166ED9990088522765E30@SJOAMSEXB01.AMERICAS.ROOT.PRI>
Date: Thu, 22 Apr 2010 16:28:07 -0700
Message-ID: <s2qd6200be21004221628nd2a93a29x7eab5841bba1c673@mail.gmail.com>
Subject: Re: core: workque: workqueue recursion when unplugging usb WCDMA 
	modem on 2.6.32 kernel
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: YuPing Luo <YuPing.Luo@csr.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 8:15 PM, YuPing Luo <YuPing.Luo@csr.com> wrote:
>> > On Tue, Apr 20, 2010 at 11:27:55PM -0700, YuPing Luo wrote:
>> Is your console on a usb to serial device?  Or a serial port?
>> if usb to serial, can you try .33-rc5 and let us know if that solves
> the problem?
>> greg k-h
>
>  The console is over serial port, while the usb modem exported 2 serial
> ports .

I don't think this is related to your console. I could easily
reproduce your problem by killing rild (which uses both the binder and
ttys). You may also what to find out why your rild is exiting.

>  The recursion can be avoided if introducing one dedicated work queue
> thread for binder (

I just pushed a fix that does exactly that.

-- 
Arve Hjønnevåg
