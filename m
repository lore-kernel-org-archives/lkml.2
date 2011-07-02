Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1GBIkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 04:40:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41248 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1GBIkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 04:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110701215740.GA13572@kroah.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-2-git-send-email-jim.cromie@gmail.com> <BANLkTin-t=OTpOMsZDxokbPrYeOH4iQ6vA@mail.gmail.com>
 <20110701215740.GA13572@kroah.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sat, 2 Jul 2011 02:39:46 -0600
Message-ID: <BANLkTi=QL+VZOKeKXXKEmd4gdOzpq4m5BQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] dynamic_debug: allow changing of dynamic_debug
 verbosity any time
To: Greg KH <greg@kroah.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        gnb@fmeh.org, jbaron@redhat.com, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 3:57 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jun 29, 2011 at 12:41:18PM +0200, Bart Van Assche wrote:
>> On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> > allow changing dynamic_debug verbosity
>> > at boot-time, with: dynamic_debug.verbose=1
>> > or at runtime with:
>> > root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose
>> >
>> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> > ---
>> >  lib/dynamic_debug.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
>> > index 75ca78f..a3b08d5 100644
>> > --- a/lib/dynamic_debug.c
>> > +++ b/lib/dynamic_debug.c
>> > @@ -58,6 +58,7 @@ struct ddebug_iter {
>> >  static DEFINE_MUTEX(ddebug_lock);
>> >  static LIST_HEAD(ddebug_tables);
>> >  static int verbose = 0;
>> > +module_param(verbose, int, 0744);
>>
>> Why 0744 and not 0644 ? Why to set the 'executable' bit ?
>
> Yeah, that's wrong, Jim, care to fix this?
>
>

yes, sorry for not ackg.
Id had it right on the pending_ct and pending_max,
this one was a d'oh

second set forthcoming, with some of the refinements
to pending queries that Jason wanted.
