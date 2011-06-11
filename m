Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1FKFlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 01:41:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52693 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1FKFlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 01:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xCjc/QBtij6zscRUkM/i1L2YSzME/e2zcyHUNR0W0MGVoWXBr3bYtl4YLlHt1Xv0wa
         H2B1FGdIAGVkVaq8jJ24Sgm7QK01Am75q4fwt9xdkq6P/mbIMQenOAR564KqHN6qKTsh
         1aB1+kpSfluCxi3fg/0ZpiSk6/pPjn7nu1NHg=
MIME-Version: 1.0
In-Reply-To: <20110610101142.GA10144@ubuntu>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
	<BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
	<alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
	<20110610101142.GA10144@ubuntu>
Date: Sat, 11 Jun 2011 08:41:38 +0300
X-Google-Sender-Auth: 1utDBuhB5Q8qvxH0DC_NciZnM-Y
Message-ID: <BANLkTi=0N7QXRvFgjHUJXBi0x=668ahXXA@mail.gmail.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
From: "Amir G." <amir73il@users.sourceforge.net>
To: Joe Thornber <thornber@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 1:11 PM, Joe Thornber <thornber@redhat.com> wrote:
> On Fri, Jun 10, 2011 at 11:01:41AM +0200, Lukas Czerner wrote:
>> On Fri, 10 Jun 2011, Amir G. wrote:
>>
>> > CC'ing lvm-devel and fsdevel
>> >
>> >
>> > On Wed, Jun 8, 2011 at 9:26 PM, Amir G. <amir73il@users.sourceforge.net> wrote:
>> > For the sake of letting everyone understand the differences and trade
>> > offs between
>> > LVM and ext4 snapshots, so ext4 snapshots can get a fair trial, I need
>> > to ask you
>> > some questions about the implementation, which I could not figure out by myself
>> > from reading the documents.
>
> First up let me say that I'm not intending to support writeable
> _external_ origins with multisnap.  This will come as a suprise to
> many people, but I don't think we can resolve the dual requirements to
> efficiently update many, many snapshots when a write occurs _and_ make
> those snapshots quick to delete (when you're encouraging people to
> take lots of snapshots performance of delete becomes a real issue).
>

If I understand this article correctly:
http://people.redhat.com/mpatocka/papers/shared-snapshots.pdf
It says that _external_ origin write updates can be efficient to readonly
(or not written) snapshots.

Could you not support readonly snapshots of an _external_ origin?

You could even support writable snapshots, that will degrade write
performance to origin temporarily.
It can be useful, if one wants to "try-out" mounting a temporary
writable snapshot, when the origin is not even mounted.
After the "try-out", the temporary snapshot can be deleted
and origin write performance would go back to normal.

Is that correct?

Amir.
