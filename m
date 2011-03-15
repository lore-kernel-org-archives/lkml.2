Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1CODIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:08:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62443 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1CODIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yGeiOTjAMyUBCvYS8z4M1KzfIUZ8CXRZp4IcF6pY3VoCGmBs2IDc6ogtJPYBgDuFP8
         ZgQiTvKrUYF9m4ZLesLNd6HG5PAG1uG9Rv21zIxtdvg5x0sKgWFffiYYhk76GQzWHlCM
         /HQNoWU1Z2OpyDphc4acCQMwXirb5xzjSoVHs=
MIME-Version: 1.0
In-Reply-To: <20110314104038.GB26085@n2100.arm.linux.org.uk>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com> <20110314104038.GB26085@n2100.arm.linux.org.uk>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 15 Mar 2011 11:07:58 +0800
Message-ID: <AANLkTinekDMZUJSyOqOuPPpuoq49wFTzc1ESGqEdezzs@mail.gmail.com>
Subject: Re: [PATCH] arm: cmpxchg syscall should data abort if page not write
 or not young
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, nicolas.pitre@linaro.org, joe@perches.com,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell King,

On Mon, Mar 14, 2011 at 6:40 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Mar 14, 2011 at 06:28:36PM +0800, Po-Yu Chuang wrote:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> If the page to cmpxchg is user mode read only (not write)
>> or invalid (not young), we should simulate a data abort first.
>
> No.  If it is not young then it should be made young.  Age is an effect
> of accesses.  It's not a permission.

OK, I will rethink about the not young part.
Thanks for your pointer.

I will resubmit a v2 which contains only the read only check.
It fixes a problem we met with futex.

best regards,
Po-Yu Chuang
