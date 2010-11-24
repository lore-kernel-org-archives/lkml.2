Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0KXKTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:19:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51818 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0KXKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Fw4ICdc11b7LzlG629esrKIljTlHrD1s932CKm9sY0NJ+Xv08aC2DWmCROZfseVqfW
         SAZMNdba04KhWqVaKkEmdUSqpAF7ys27ei7WAJdtUuwHlhS8+08qp7hmWLZXBfmZV1aw
         T87F1dNawnuJeX47Ui1ZtAUIpr18R9SINU/cc=
From: Francis Moreau <francis.moro@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: How about limiting refresh ioctl to sampling events ?
References: <m3zkt05h3w.fsf@gmail.com> <1290517646.2072.403.camel@laptop>
	<m3vd3o5g9u.fsf@gmail.com> <1290519980.2072.404.camel@laptop>
Date: Wed, 24 Nov 2010 11:19:08 +0100
In-Reply-To: <1290519980.2072.404.camel@laptop> (Peter Zijlstra's message of
	"Tue, 23 Nov 2010 14:46:20 +0100")
Message-ID: <m21v6bdnxf.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

[...]

>> I'm also wondering if you would accept a second patch which will
>> introduce:
>> 
>> static inline bool is_sampling_event(struct perf_event *event)
>> {
>>         return event->attr.sample_period != 0;
>> }
>> 
>> That would make the code slighlty easier to read IMHO.
>> 
>
> Sure, Francis might want that too, he found another something like this.

Yes there's another issue when counting events are used: they call
perf_event_output() when 'period_left' gets 0 where as they should not.

-- 
Francis
