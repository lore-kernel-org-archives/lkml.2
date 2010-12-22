Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0LVSLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:11:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0LVSLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:11:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CFlO5no3ZwWq2Ig8EcWK4alk5+yVjPQV6aWbsEhvEJufyqhwsuYE7YmDCCF2t3ZxV6
         yF8Z2hb1qJy508UwSvRMxF8LG0IYvU3f0mhDrtH9kMaoPQz89NEPfvLc9CDWCEo8KBbt
         5Xen3doiCeaKYc/Bw6VfVSKWdZpxOjP7IcEJE=
MIME-Version: 1.0
In-Reply-To: <20101222180428.GD1739@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<20101202174328.GA1750@nowhere>
	<201012161449.52318.roucaries.bastien@gmail.com>
	<201012221850.51242.roucaries.bastien@gmail.com>
	<20101222180428.GD1739@nowhere>
Date: Wed, 22 Dec 2010 19:11:43 +0100
Message-ID: <AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 7:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Dec 22, 2010 at 06:50:48PM +0100, Bastien ROUCARIES wrote:
>> Le jeudi 16 décembre 2010 14:49:48, Bastien ROUCARIES a écrit :
>> > Le jeudi 2 décembre 2010 18:43:32, vous avez écrit :
>> > > On Fri, Nov 26, 2010 at 05:57:05PM +0100, Bastien ROUCARIES wrote:
>> > > > Dear frederic,
>> I achieve to reproduce it. BTW it is my home partition with acl enable
>
> How do you know you reproduced it? You had a crash before using SysRq?
> Or you felt a deadlock or so?
>
> What's interesting is that report is that there is no blocked task
> that holds the reiserfs lock.
>
> So I really feel the problem is that someone opened the journal but did not
> release it.

Could you add a virtual lock for testing this hypothesis ? This lock
will be held during journal opening and releasing during journal
closing, using lockdep for testing this hypothesis ?
>
> How hard is it to reproduce now? If it's not so hard or haphazard, we should
> start a bisection. Otherwise I think we'll need to do some tracing and this
> is going to take several tries :)
>
