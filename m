Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1CGVsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:48:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62024 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1CGVse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l6LAtqDwoRaVcMMkBr5K1eh47zw3e5gjKGWATevi597Wolt1wp87b51UWRXBeiKtza
         O2VwkdvWcvr4GhdU9m2SQCfLSaEA0StAnBSqspStbeKaTl+UpKTxyn2TcTKhC8PP5Eqj
         I4LxcFS7B0154BHJW3WeJ0ODd/gjQwrGf2BM4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimsrmGdBEEpV7OPFtGG=yRfeVBPxGP5y8gkUHfJ@mail.gmail.com>
References: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTi=w=5L8tbjGDCgoRpjRXYrNxsfWaE2SL4XG9+pY@mail.gmail.com>
	<AANLkTimsrmGdBEEpV7OPFtGG=yRfeVBPxGP5y8gkUHfJ@mail.gmail.com>
Date: Mon, 7 Mar 2011 23:48:33 +0200
Message-ID: <AANLkTikEn5ZS1D8LhVLepMLHxyOki0q8Qy-k9SwjNgse@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 9:29 PM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
> On Mon, Mar 7, 2011 at 12:02 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Mon, Dec 20, 2010 at 7:12 PM, Felipe Contreras
>> <felipe.contreras@nokia.com> wrote:
>>> We need to protect not only the dmm_map list, but the individual
>>> map_obj's, otherwise, we might be building the scatter-gather list with
>>> garbage. So, use the existing proc_lock for that.
>>>
>>> I observed race conditions which caused kernel panics while running
>>> stress tests. This patch fixes those.
>>
>> I just heard that Tuomas Kulve is getting a lot of panics on Gumstix
>> Overo. I propose we apply this patch on the stable tree ASAP, and if
>> there's no better proposals, also on .38.
>
> Can you or Tuomas share the bug report data (panic log, test case
> maybe)? I would like to discard issues affected by timing that could
> be hidden with this patch.

I got this from Tuomas:
http://pastie.org/1643677

It seems it's very easy to reproduce on Gumstix Overo with a
gst-launch command. The way I reproduced it was very tedious; running
a full blown Maemo test suite with GBs of clips.

I think the issue is very clear; if you build a sg list with garbage
memory, problems are expected =/

> I agree that for the time being this needs to be sent upstream, even
> if in paper Ohad's patch solves the issue without side effects of
> locking.

Perhaps. I don't remember if I ack'ed Ohad's patch, but even if it's
ok, I think it can be applied on top of my patch.

Cheers.

-- 
Felipe Contreras
