Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1AZVuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:50:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1AZVub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:50:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ngvYxarSe66Ag9HX4R5rsn28G7MDtiB819ZfSUjd7tyYmWQcjI1c5/Irecs2l2Ljln
         FOToktDIjhDo7SmhuK2A==
MIME-Version: 1.0
In-Reply-To: <20110126024831.GD28283@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
 <20110125020658.GA3481@kroah.com> <AANLkTinLoDN_6zG56J7V154jrRc-K+BzAHFO3qS_r8J0@mail.gmail.com>
 <4D3F4275.50709@garzik.org> <AANLkTim4fG0-F0+E-DHa4=XGdk1rFbRA68nvt9bfURiK@mail.gmail.com>
 <4D3F4699.60809@garzik.org> <AANLkTinUmB003g3Cb0yUXf7LeTvc=BMWN6MGcGJW0QrJ@mail.gmail.com>
 <20110126024831.GD28283@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Wed, 26 Jan 2011 13:50:06 -0800
Message-ID: <AANLkTikyMswC7eNaambOAmCVQ3uxcZSiikigkTOxYciE@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
To: Greg KH <greg@kroah.com>
Cc: Aaron Durbin <adurbin@google.com>, Jeff Garzik <jeff@garzik.org>,
        torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:48 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 25, 2011 at 02:21:03PM -0800, Aaron Durbin wrote:
>> As Mike talked about it might be more desirable to actually pass a
>> reason field that indicates the appropriate kernel event. However, the
>> naming of some of the variables becomes less clear. Maybe name it
>> panic_oops_notifier_list? That way there would only be a single
>> notifier chain.
>
> Yes, I think that's the better thing to do here instead of adding more
> notifier chains.  It would just start to get even messier than it
> currently is :)

Hmm.  I'm going to try and just re-use the notify_die() bits here
instead which seems to do what I want.  The overloading of "die" is a
bit of a mess, which is probably why I missed it the first time
around.
