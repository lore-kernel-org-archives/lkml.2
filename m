Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1ESPBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:01:43 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:37991 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab1ESPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ttEBC9q7VylZ6J+zGT6wTrbBRYH5OguVUbdGknEuGoPd78BjXSosX0axTwCbxA0Q4q
         K0xXp2t+J1sjfM12nDifGq0Vq9L7lbwbvft0j0bZj9278sXGHNJH0AQyGSpDvJ2bpVVe
         eOOIoYpM/7CchP6q84B7uWXQpQix4lYBKTBGs=
MIME-Version: 1.0
In-Reply-To: <20110519153928.40521b93@lxorguk.ukuu.org.uk>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <20110519144312.38177704@lxorguk.ukuu.org.uk> <BANLkTikFRwPY_qOQpPmCmNUJbBUsGcuGUw@mail.gmail.com>
 <20110519153928.40521b93@lxorguk.ukuu.org.uk>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Thu, 19 May 2011 17:01:02 +0200
Message-ID: <BANLkTi=d+d7FZia5b5URDmcr=4bZnMccPA@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 4:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > That at least cuts down most failures (but not all - eg commits with a network
>> > component such as email receives)
>>
>> I don't understand your email example.
>
> Think about sendmail and SMTP
>
> Mail arrives
> Commit to disk
> fsync
> [X]
> Confirm receipt to other system
> Other system removes it from the queue it holds
>
> So if it crashes at X even though you've kept ordering and you've
> got an internally consistent view (as if it crashed earlier), that
> has been observed and acted upon by another system - so your email
> just went into the cosmic trashcan.
>
>
Ok, I think I understand your example. But isn't that the user's risk
and more a problem of the general idea of laptop mode? If I enable
laptop_mode and set MAX_LOST_WORK_SECONDS, I risk to lose data. I
would say that includes email and whatever else may happen. (And if I
don't switch it on, I risk running out of battery and being unable to
create data...). btw. I don't think it would be a good idea for people
to use sendmail or other crucial data storage applications with
laptop_mode active. I would see this as a switch for e.g. notebooks at
conferences, in class, lectures, etc.

(sorry, lost the CCs)
