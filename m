Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab1D3AAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:00:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab1D3AAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PfONSjt/I2SciuKfYuDFtpAEpAUnGS7PHKyeYdLa4KoIOn02/fmze7R9UOjqIa5LUQ
         0Pq4E1tmWMHqyfYBEu3w==
MIME-Version: 1.0
In-Reply-To: <20110429164736.fd84f2ae.randy.dunlap@oracle.com>
References: <20110429212328.GA19207@kroah.com> <20110429225551.22013.65012.stgit@mike.mtv.corp.google.com>
 <20110429164736.fd84f2ae.randy.dunlap@oracle.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 29 Apr 2011 16:59:43 -0700
Message-ID: <BANLkTi=6oA+6-eLgczy30CDw1OGABXrjrw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] driver: Google EFI SMI
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 4:47 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Fri, 29 Apr 2011 15:55:51 -0700 Mike Waychison wrote:
>
>
>> +static int gsmi_die_callback(struct notifier_block *nb,
>> +                          unsigned long reason, void *arg)
>> +{
>> +     if (reason == DIE_NMIWATCHDOG)
>> +             gsmi_shutdown_reason(GSMI_SHUTDOWN_NMIWDT);
>> +     else if (reason == DIE_OOPS)
>> +             gsmi_shutdown_reason(GSMI_SHUTDOWN_OOPS);
>> +     return NOTIFY_DONE;
>> +}
>
>
> Where is DIE_NMIWATCHDOG defined?

My bad.  I didn't rebase these 3 patches to v2.6.39-rc5 when sending
out v4.  Seems it got dropped in rc1 in 02ca752e.  Looking at how to
wire this into whatever replaced die_nmi() now.
