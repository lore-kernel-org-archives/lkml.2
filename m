Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1DEMvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:51:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40959 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1DEMu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ib9POPJNYracCroZj7Ru7/03Psiy8b4IrnK+8M/thr7zdoNpjhwjCAEm/N70PkmQI+
         CeJ8kMOryD7kCR/TQ+dLRRyklQLioIKW099Z6ND/SQ7NuqFB0gAxSCUKjH7WO5BFJ+Ww
         gnKtXbHtNUjYC/EEM1gQN/l1JwgeQu50bQl1w=
MIME-Version: 1.0
In-Reply-To: <BANLkTinYJHxO4KL6xEzQB1Q-YAdggNL9Wg@mail.gmail.com>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
	<20110401172241.GA26851@srcf.ucam.org>
	<BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
	<20110402100043.GA5890@kamineko.org>
	<BANLkTikVGWM3T1y2XvwkHB+Yub5EhG1RPA@mail.gmail.com>
	<20110402155549.GA6724@kamineko.org>
	<BANLkTimJa3CSWouTMJD5V0ZuMa67YXy88Q@mail.gmail.com>
	<20110404234448.GA24957@kamineko.org>
	<BANLkTinYJHxO4KL6xEzQB1Q-YAdggNL9Wg@mail.gmail.com>
Date: Tue, 5 Apr 2011 15:50:56 +0300
Message-ID: <BANLkTin43y37DDWo9hCLVi9Gua1C3O=Law@mail.gmail.com>
Subject: Re: sony-laptop: fix early NULL pointer dereference
From: Dan Carpenter <error27@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrea Gelmini <andrea.gelmini@gmail.com>, anssi.hannula@iki.fi,
        linux-acpi@vger.kernel.org, axel.lin@gmail.com, trenn@suse.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/11, Thiago Farina <tfransosi@gmail.com> wrote:
> On Mon, Apr 4, 2011 at 8:44 PM, Mattia Dongili <malattia@linux.it> wrote:
>> Author: Mattia Dongili <malattia@linux.it>
>> Date:   Fri Apr 1 10:01:41 2011 +0900
>>
> I think most of the patches doesn't include these above lines nor the
> subject line in the description.

Just ignore those lines.  It's a git thing.

> Also when submitting a patch to the
> list, please don't forget to put [PATCH] on the subject line.
>

Yeah.  [patch v2].  But it's too late to fix that so don't worry about it.

> git format-patch should output the right format.
>
>>    sony-laptop: fix early NULL pointer dereference
>>
>>    The SNC acpi driver could get early notifications before it fully
>>    initializes and that could lead to dereferencing the sony_nc_handles
>>    structure pointer that is still NULL at that stage.
>>    Make sure we return early from the handle lookup function in these
>>    cases.
>>
>>    Signed-off-by: Mattia Dongili <malattia@linux.it>
>> ---
>>
>> Hi Matthew,
>> if it's not too late, can you pick this one up instead of the previous
>> one (89ec2feafaedd759e53346d641f60863a14cfb9e)?
>> If it's too late I'll try and do a round of return value fixes later.

Don't worry about it.  Probably the real fix is to make checkpatch.pl
complain if you return -1 instead of a proper error code.

>>
>> diff --git a/drivers/platform/x86/sony-laptop.c
>> b/drivers/platform/x86/sony-laptop.c
>> index b2ce172..de79c18 100644
>> --- a/drivers/platform/x86/sony-laptop.c
>> +++ b/drivers/platform/x86/sony-laptop.c
>> @@ -810,6 +810,11 @@ static int sony_nc_handles_cleanup(struct
>> platform_device *pd)
>>  static int sony_find_snc_handle(int handle)
>>  {
>>        int i;
>> +
>> +       /* not initialized yet, return early */
> This comment is useless, it is just repeating what the codes does ;) I
> think you can just remove it.

Whatever...  Let's just merge this fix and let's move on.

regards,
dan carpenter

>
>> +       if (!handles)
>> +               return -EINVAL;
>> +
>>        for (i = 0; i < 0x10; i++) {
>>                if (handles->cap[i] == handle) {
>>                        dprintk("found handle 0x%.4x (offset: 0x%.2x)\n",
