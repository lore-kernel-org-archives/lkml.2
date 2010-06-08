Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0FHUDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:03:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37310 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab0FHUDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:03:49 -0400
MIME-Version: 1.0
X-Originating-IP: [174.31.27.127]
In-Reply-To: <20100608132144.GA4775@phenom.dumpdata.com>
References: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
	<20100607162817.GA13468@phenom.dumpdata.com>
	<AANLkTim1KloQ4qZTsqHmt2U33dUjM-DDr9-dpooXTx52@mail.gmail.com>
	<20100608132144.GA4775@phenom.dumpdata.com>
Date: Tue, 8 Jun 2010 13:03:49 -0700
Message-ID: <AANLkTim4drroXSxsYkngQWiKL2FjIln4ZBf8zKyPLaJN@mail.gmail.com>
Subject: Re: broadsheetfb and fbcon
From: Robert Emanuele <rob@emanuele.us>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, jayakumar.lkml@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 6:21 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Jun 07, 2010 at 10:19:27AM -0700, Robert Emanuele wrote:
>> There are no module parameters for fbcon or broadsheetfb.
>>
>> On Mon, Jun 7, 2010 at 9:28 AM, Konrad Rzeszutek Wilk
>> >> Are those kind of updates a limit of the broadsheet driver or fbcon?
>> >
>> > I thought there was an update value on how often it should redraw. Did
>> > you do a modinfo on the driver?
>
> Please do not post your response on top.
>
> What I was thinking about is the delay variable:
>
> 1056 static struct fb_deferred_io broadsheetfb_defio = {
> 1057         .delay          = HZ/4,
> 1058         .deferred_io    = broadsheetfb_dpy_deferred_io,
> 1059 };
> 1060
>
>
> Try changing that to a higher number and seeing if that fixes your
> problem. If so, you and I can work on a patch that sets a parameter
> for this.
>

Increasing the delay value to a larger value (more updates/sec) or a
smaller value (fewer updates/sec) in the broadsheet driver does not
affect the screen update rate.  Does the fbcon used the deferred io
handler?

Thanks,

Rob
