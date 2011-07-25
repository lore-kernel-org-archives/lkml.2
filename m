Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1GYLLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:11:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60659 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1GYLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:11:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxyWTTBk46dLtgkpxJASxyXG4JuSeir_E-mdsadi2d1awA@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-9-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-piFe5mEPf82Mm8gmiqX2SiPTOVpNDY-3C22PNA6MxXsg@mail.gmail.com> <CAJfuBxyWTTBk46dLtgkpxJASxyXG4JuSeir_E-mdsadi2d1awA@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 25 Jul 2011 13:10:58 +0200
X-Google-Sender-Auth: hVcj1faQuwN3at8cwty9ONOlbrs
Message-ID: <CAO+b5-oXKFYo63cLfnfQntArzcsrfKE-8dX5fTpOwuNDTBPMBQ@mail.gmail.com>
Subject: Re: [PATCH 08/21] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 11:32 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> using kasprintf would entail;
> - a local char* var,
> - a call to the string-producer (show_ddebug_query above)
> - a kfree(var)
> all in the caller context.
> Using a preallocated string buffer avoids this,
> and is slightly more efficient wrt kallocs.

I'm still missing an explanation why the static variable "prbuf_query"
is necessary. Wouldn't eliminating that static variable make the code
more elegant ?

Bart.
