Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab0JYXzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:55:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33064 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab0JYXzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=VOht7nEFYStv65tyRq0EvN0W0bEhD4wbl9fg1KVJnNxMXE+Uc4Iz2bA4q2Pv0DzVdi
         BrxWxU8NH+SSrg0scD3DgUh4zuy6o5xp4kAZ2gnu5avgP23ZL4Rbr4Ak4RUJhqYt7YPB
         UZyczqhI6SorQ8iSl1kCo8uTH9RFdSv75aAYo=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20101025175535.GC16246@opensource.wolfsonmicro.com>
References: <1287972667.23608.2.camel@mola> <1287973026.23608.6.camel@mola> <20101025175535.GC16246@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 26 Oct 2010 07:55:25 +0800
Message-ID: <AANLkTi=D6Rwmqqd=Si_QgR=r1siRgiJ86uir5S8sWeEG@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: max8952 - fix max8952_set_voltage
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Oct 25, 2010 at 10:17:06AM +0800, Axel Lin wrote:
>> In current implementation, vid is declared as u8,
>> then "vid == -1" is always false, and "vid >= 0" is always true.
>> Thus change it to s8.
>>
>> vid is always less than MAX8952_NUM_DVS_MODE in current implementation,
>> thus remove the cheking for "vid < MAX8952_NUM_DVS_MODE".
>
> This bit seems like reasonable paranoia in the face of future code
> changes and we're not really in a sufficiently fast path to worry about
> cycles - are you sure that this is essential?
>
Ok. I will send a v2 thant only change u8 to s8.

Regards,
Axel
