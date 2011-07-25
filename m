Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1GYN4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:56:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52243 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1GYN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:56:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-oXKFYo63cLfnfQntArzcsrfKE-8dX5fTpOwuNDTBPMBQ@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-9-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-piFe5mEPf82Mm8gmiqX2SiPTOVpNDY-3C22PNA6MxXsg@mail.gmail.com>
 <CAJfuBxyWTTBk46dLtgkpxJASxyXG4JuSeir_E-mdsadi2d1awA@mail.gmail.com> <CAO+b5-oXKFYo63cLfnfQntArzcsrfKE-8dX5fTpOwuNDTBPMBQ@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 25 Jul 2011 07:56:00 -0600
Message-ID: <CAJfuBxyUwYV7Hf0+BTyz+hcB5hCVNrKePb-hSKv4Bs7OMU7Fgg@mail.gmail.com>
Subject: Re: [PATCH 08/21] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 5:10 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Sat, Jul 16, 2011 at 11:32 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> using kasprintf would entail;
>> - a local char* var,
>> - a call to the string-producer (show_ddebug_query above)
>> - a kfree(var)
>> all in the caller context.
>> Using a preallocated string buffer avoids this,
>> and is slightly more efficient wrt kallocs.
>
> I'm still missing an explanation why the static variable "prbuf_query"
> is necessary. Wouldn't eliminating that static variable make the code
> more elegant ?
>
> Bart.
>

After further consideration, Ive done it as you suggest.
Its a few more lines of code, but less complex -
all kfrees follow use immediately, no buffer mgmt at a distance.
