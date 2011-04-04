Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1DDHhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:37:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1DDHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xzEwDGJtBoko8rkpBNrSlwjDwIirUWWHsvyUs+qsJQGXqo6DWXDbVREtnkAFbn/o5D
         4ZOoYgHa0zH9Ic2cF5VkqGlrgjsLCWspqNZMB2VtBddVfluSJHTw4kBBdbquuVHBo6kw
         SQdh5ooRWOTOYBhqTEsGHoj4AiHUu7G8N6AH4=
MIME-Version: 1.0
In-Reply-To: <20110402155549.GA6724@kamineko.org>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
	<20110401172241.GA26851@srcf.ucam.org>
	<BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
	<20110402100043.GA5890@kamineko.org>
	<BANLkTikVGWM3T1y2XvwkHB+Yub5EhG1RPA@mail.gmail.com>
	<20110402155549.GA6724@kamineko.org>
Date: Mon, 4 Apr 2011 10:37:17 +0300
Message-ID: <BANLkTimJa3CSWouTMJD5V0ZuMa67YXy88Q@mail.gmail.com>
Subject: Re: Regression 2.6.39-rc1 for sony-laptop
From: Dan Carpenter <error27@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, anssi.hannula@iki.fi,
        linux-acpi@vger.kernel.org, axel.lin@gmail.com, trenn@suse.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/11, Mattia Dongili <malattia@linux.it> wrote:
> On Sat, Apr 02, 2011 at 02:55:38PM +0300, Dan Carpenter wrote:
>> On 4/2/11, Mattia Dongili <malattia@linux.it> wrote:
>> > --- a/drivers/platform/x86/sony-laptop.c
>> > +++ b/drivers/platform/x86/sony-laptop.c
>> > @@ -810,6 +810,11 @@ static int sony_nc_handles_cleanup(struct
>> > platform_device *pd)
>> >  static int sony_find_snc_handle(int handle)
>> >  {
>> >  	int i;
>> > +
>> > +	/* not initialized yet, return early */
>> > +	if (!handles)
>> > +		return -1;
>>
>> -1 is -EPERM.  That's not the right error code here.  Maybe -EINVAL?
>
> this error is not propagated to userspace. If necessary I can review all
> error codes in the sony-laptop internal functions (where -1 is a fairly
> common return code for error conditions).

That would be good, but it's going beyond the call of duty.  The main thing
is to not introduce new slop.

>
> I remember a discussion on LKML recently about error codes but I'm not
> sure what the outcome was (if any).
>

People sometimes think -1 is a generic error code, but it's not.  It has
a specific wrong meaning.  In fact, -1 is never the right error code.
It's should
either be -EPERM, or the appropriate error code.

regards,
dan carpenter
