Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0GNG3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:29:19 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45273 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0GNG3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZZZ13f+33Dz80kFnidupi3qIazW+p8YRvV7k2HaeQt71Wf0BHFWAo3yzR8oI+uU0Yf
         phkChKuxvzIQdfn8AlLvbCSxAmtIv2nkUL1Pp4WUkwd7oVxly+EpnXY4eRUgfH20rDKs
         mhXLY9FprOGwddjtw4sSbFI55MpzDMp1MY9Tw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWK9mX6lVUvWzgbh7QQ3ZItnrUE4WBJEkOqm2q@mail.gmail.com>
References: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>
	<1278594883.3313.33.camel@localhost.localdomain>
	<AANLkTilMKH5M0d8iyACTDLMwZb1WgyJVrd9e04H2cy95@mail.gmail.com>
	<AANLkTinWK9mX6lVUvWzgbh7QQ3ZItnrUE4WBJEkOqm2q@mail.gmail.com>
Date: Wed, 14 Jul 2010 15:29:15 +0900
Message-ID: <AANLkTilI8klNawzxVc-wxREJwktBKW2G4GvYeyMueGJM@mail.gmail.com>
Subject: Re: [Linux-ima-user] [RFC][PATCH] ima: add default rule for initramfs 
	files
From: Seiji Munetoh <seiji.munetoh@gmail.com>
To: Shaz <shazalive@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        Roberto Sassu <roberto.sassu@polito.it>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 2:42 PM, Shaz <shazalive@gmail.com> wrote:
>
>
> On Wed, Jul 14, 2010 at 3:08 AM, Seiji Munetoh <seiji.munetoh@gmail.com>
> wrote:
>>
>> On Thu, Jul 8, 2010 at 10:14 PM, Mimi Zohar <zohar@linux.vnet.ibm.com>
>> wrote:
>> > On Tue, 2010-07-06 at 17:08 +0200, Roberto Sassu wrote:
>> >> This patch modifies the default policy shipped with IMA, in order to
>> >> avoid measurements
>> >> of files in the initial ramdisk. Those files can be measured early in
>> >> the boot process
>> >> by the bootloader.
>> >> The patch applies to latest version of the mainline kernel 2.6.35-rc4.
>> >
>> > Yes, the initramfs measurements are therefore redundant, as they're
>> > already included in the initramfs measurement, but perhaps, as the
>> > number of initramfs is very limited and the individual file measurements
>> > supplies additional information, it wouldn't hurt to keep the individual
>> > file measurements as well.  These measurements could potentially help in
>> > identifying initramfs changes.
>> >
>> > Would appreciate other opinions before accepting this change.
>>
>> The hash value of the initramfs is unstable since it was generated
>> at the time of kernel installation.
>> So still I want to check  the individual used file in initramfs.
>
> If initrd is measured by boot loader then changes to individual files should
> not be measured as this IS redundant. Use the new hash of the initrd as an
> integrity metric. Why would this not be enough?

This depends on remote verifier.
Creating the initramfs is client side task and  the hash value of initramfs
will vary each clients.

For me, validation of  current measurements is easier than validation of
initramfs. And it seems the overhead of this redundancy is less painful.

But some system can validate (or trust) the initramfs measured by IPL.
So, I would suggest that add Kconfig option to change the default policy.

IMHO, if the eventlog contains fsmagic information for each measurements.
Verifier can skip the validation of RAMFS measurement easily.

--
Seiji
