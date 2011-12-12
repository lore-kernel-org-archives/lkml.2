Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1LLMzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:55:47 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40125 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1LLMzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:55:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfyv35=J_BhxXBF-FrV0DfW1h6eo6MxXMpB2d4+WseujXAeoA@mail.gmail.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	<CAAfyv35=J_BhxXBF-FrV0DfW1h6eo6MxXMpB2d4+WseujXAeoA@mail.gmail.com>
Date: Mon, 12 Dec 2011 14:55:45 +0200
Message-ID: <CAEnQRZAoWC9KiD00n7UihT1Urj=bM18=xFEaXckSDukO0fEmFQ@mail.gmail.com>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 2:51 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> On Mon, Dec 12, 2011 at 1:44 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
>> We can easily get kref refcount value by accesing
>> kref->refcount but it is better to have a function
>> for this.
>>
>> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
>> ---
>>  include/linux/kref.h |    1 +
>>  lib/kref.c           |    9 +++++++++
>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kref.h b/include/linux/kref.h
>> index d4a62ab..cd1b04a 100644
>> --- a/include/linux/kref.h
>> +++ b/include/linux/kref.h
>> @@ -22,6 +22,7 @@ struct kref {
>>  };
>>
>>  void kref_init(struct kref *kref);
>> +atomic_t kref_read(struct kref *kref);
>>  void kref_get(struct kref *kref);
>>  int kref_put(struct kref *kref, void (*release) (struct kref *kref));
>>  int kref_sub(struct kref *kref, unsigned int count,
>> diff --git a/lib/kref.c b/lib/kref.c
>> index 3efb882..48aaf2a 100644
>> --- a/lib/kref.c
>> +++ b/lib/kref.c
>> @@ -25,6 +25,15 @@ void kref_init(struct kref *kref)
>>        smp_mb();
>>  }
>>
>> +/**
>> + * kref_read - read refcount for object
>> + * @kref: object.
>> + */
>> +void kref_read(struct kref *kref)
>> +{
>> +       return atomic_read(&kref->refcount);
>> +}
> Return void? Shouldn't be: atomic_t. Did you compile your code before
> submission???

You are right. I'll send again with the correct version.

thanks,
Daniel.
