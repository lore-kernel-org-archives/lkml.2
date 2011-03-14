Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1CNUCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:02:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1CNUCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YsMXwMNoHHDQmV8Dah31tYp/3gPSD0VTYoowwBS0iInZjfVbwblqYlHgKJWUhBFmTi
         owWQKHeApz4dlIrTR2MA==
MIME-Version: 1.0
In-Reply-To: <20110314154713.GF31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014353.6133.94204.stgit@mike.mtv.corp.google.com> <20110314154713.GF31340@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 14 Mar 2011 13:01:50 -0700
Message-ID: <AANLkTikhhYv2=memo-Rkhh1pG3v4-edrUROTgLoc6cbd@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] driver: Google EFI SMI
To: Greg KH <greg@kroah.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 8:47 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Mar 11, 2011 at 05:43:53PM -0800, Mike Waychison wrote:
>> The "gsmi" driver bridges userland with firmware specific routines for
>> accessing hardware.
>
> As with the other driver in this series, what keeps this driver from
> being loaded on hardware that does not support this functionality?  If
> it is loaded, will it cause bad things to happen?

gsmi itself is better guarded than the memconsole driver that the x86
maintainers objected to.

It relies on keying off of a couple different strings, looking for
"GOOGLE" as either the OEM ID in the  FADT table, or "Google, Inc." as
the board vendor.  We further discriminate whether the driver should
load (it doesn't apply to all of our boards) with a couple other
checks.  See gsmi_system_valid().  I've added a comment to the patch
description indicating this for the upcoming v3 send-out.

>
> Also, what causes it to be loaded on hardware that needs it?  There
> should be some MODULE_DEVICE_TABLE somewhere in this thing to cause it
> to be autoloaded?

I don't know if there is a good way to have this guy autoloaded, but
that's probably fine. We will likely compile it in as a built-in or
adjust our userland to have the module loaded.  We use it on all
machines we've been building for the last 4-5 years, and a table of
device IDs would just contain a list of a bunch of parts that aren't
really google-specific.
