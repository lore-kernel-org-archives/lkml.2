Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2KFPZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:25:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab2KFPZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:25:06 -0500
Date: Tue, 6 Nov 2012 16:24:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/11] HID: hid-input: add usage_index argument in
 input_mapping and event.
In-Reply-To: <CAN+gG=GiAsn-5kefjRj_xgFfbuEXxj_PL7PaPES05wiZs+J-Ug@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1211061624220.24253@pobox.suse.cz>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com> <1351241067-9521-4-git-send-email-benjamin.tissoires@gmail.com> <20121029192558.GA15061@polaris.bitmath.org> <CAN+gG=HLmCszdxgdcmt5AgzNyt08HamCdd2BjzCaTB5k7wYcnQ@mail.gmail.com>
 <CAN+gG=GiAsn-5kefjRj_xgFfbuEXxj_PL7PaPES05wiZs+J-Ug@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Benjamin Tissoires wrote:

> >>> Currently, there is no way to know the index of the current field
> >>> in the .input_mapping and .event callbacks  when this field is inside
> >>> an array of HID fields.
> >>> This patch forwards this index to the input_mapping and event
> >>> callbacks.
> >>
> >> I agree with the idea, but the function argument list is becoming
> >> ridiculously long... Could we remove the usage pointer argument, at
> >> least?
> >
> > yeah, totally agree. Let me just check whether it will not introduce
> > more problems than it solves for my driver.
> 
> Well, after a deeper look, it's a really bad idea. Every drivers that
> implements input_mapping, input_mapped, event use at least once the
> struct usage. So this would require change nearly every hid driver.
> 
> To solve that, and to minimize the impact on the other drivers, I'm
> going to add a field in struct usage with the appropriate index.

Yes please, I like that solution more as well.

Thanks,

-- 
Jiri Kosina
SUSE Labs
