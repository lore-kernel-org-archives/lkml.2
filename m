Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1AYUCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:02:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14270 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1AYUB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:01:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EwpONhXDl018IIfL+drjQJd2sc3pE51ELvY4MDz02+R2rSivVGxs6uDvMNnyDLi6dM
         GK8eIg1aq0u1ye5HHUmA==
MIME-Version: 1.0
In-Reply-To: <20110125020658.GA3481@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com> <20110125020658.GA3481@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 25 Jan 2011 12:01:35 -0800
Message-ID: <AANLkTinLoDN_6zG56J7V154jrRc-K+BzAHFO3qS_r8J0@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 6:06 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jan 24, 2011 at 04:24:39PM -0800, Mike Waychison wrote:
>> From: Aaron Durbin <adurbin@google.com>
>>
>> Later firmware patches in this series would like to be able to be
>> notified whenever an oops occurs on the system, so that it can be
>> recorded in the boot log.
>>
>> This patch introduces a notifier_block called "oops_notifier_list"
>> so that drivers can register to get called whenever an Oops is
>> triggered.
>
> But we already have a panic notifier list.  Why create a new one?
> What's wrong with the existing one that doesn't work properly for you?

AFAICT, the panic notifier list doesn't get called on oops.  Should we
reuse it and actually add meaning to the 'reason' argument?  It does
become a misnomer if we do that :\
