Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0KKGLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:11:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55924 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0KKGLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RdhOMWF/jWh55FSxGnXU2OhP20bxIHYdl5UQNAgVZxwA26ySI5Z3tO3y/9CwY6I/NR
         eufOTlW+eTQ88FeuzLi3EtHpwiXBF4i7TBo3QlVhxxp4z9eiDui+O9coysydaebmmoE6
         tviJvH18dzWNMziGXG86Eug5izXFGLMpv565g=
MIME-Version: 1.0
In-Reply-To: <20101110183940.GA15089@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
	<20101109224450.GB21992@kroah.com>
	<AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com>
	<20101110183940.GA15089@kroah.com>
Date: Thu, 11 Nov 2010 12:11:34 +0600
Message-ID: <AANLkTimTy0vngwuM=jWfeU7qgqznamPgAftX7=2LShL+@mail.gmail.com>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:39 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 10, 2010 at 10:53:37AM +0600, Rakib Mullick wrote:
>> On Wed, Nov 10, 2010 at 4:44 AM, Greg KH <greg@kroah.com> wrote:
>> >
>> > If it's really not used then why would marking it inline help out any?
>> > Shouldn't we just delete the function instead?
>> >
>> As far as I can see, its been called recursively and also from
>> sysfs_add_one. Am I missing anything?
>
> If so, then what is the compiler warning that is being generated that
> you are trying to resolve?
>

Yes - its really confusing. Actually, sysfs_pathname is called from
WARN(). So - when #ifndef WARN is false, then we're having that
problem and sysfs_pathname isn't used that time. So, the proposed
patch isn't the correct fix. Maybe, splitting up the WARN message and
calling sysfs_pathname is the correct one. Am I right?




> totally confused,
>
> greg k-h
>
