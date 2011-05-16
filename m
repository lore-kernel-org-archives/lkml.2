Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1EPIpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:45:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64141 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1EPIpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bf4yAXP1x6tWIq3KiA97dkGNo3Iqytmi5NaoxGguA3Rd3OfQWZ42i4q0xwJbImAjsr
         bviw/tnoItrWDQXmvbUILSkoe7V3QE76YyH3yJ92ZHSqoq5CZ64jhYolCarxh4134MNr
         KqqGbtks/voSj2sqTqh66wMgkwklwLd9qkis0=
MIME-Version: 1.0
In-Reply-To: <20110516080844.GC27635@elte.hu>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
	<20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
	<20110516080844.GC27635@elte.hu>
Date: Mon, 16 May 2011 12:45:39 +0400
X-Google-Sender-Auth: TGYpnNIKGh5cY2ETPvupco7fFIU
Message-ID: <BANLkTimAYf1BBAqDpVbc9jRWtfHcg2SbNQ@mail.gmail.com>
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic selection
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
        hpa@zytor.com, steiner@sgi.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>> From: Suresh Siddha <suresh.b.siddha@intel.com>
>> Subject: x84_64, apic: Use probe routines to simplify apic selection
>>
>> Use the unused probe routine in the apic driver to finalize the apic model
>> selection. This cleans up the default_setup_apic_routing() and this probe
>> routine in future can also be used for doing any apic model specific
>> initialization.
>>
>> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>> ---
>>  arch/x86/kernel/apic/apic_flat_64.c   |   10 +++++++++-
>>  arch/x86/kernel/apic/probe_64.c       |   22 +++++++---------------
>>  arch/x86/kernel/apic/x2apic_cluster.c |    7 ++++++-
>>  arch/x86/kernel/apic/x2apic_phys.c    |   10 +++++++++-
>>  arch/x86/kernel/apic/x2apic_uv_x.c    |    7 ++++++-
>>  5 files changed, 37 insertions(+), 19 deletions(-)
>
> Ok, looks like a step forward in the right direction.
>
> Wouldnt it be more self-contained if the probe function returned an apic driver
> pointer?
>
> We could add an __apicdriver section trick to 'know' about all APIC probing
> functions - and we'd call them one by one and use the first one that returns a
> non-NULL result.
>
> Then we'd have the generic fallback APIC drivers as well - not marked
> __apicdriver but used by the probe function directly.
>
> Or we could have them as __apicdriver as well, but then the .o link ordering
> matters to probing order.
>
> Thanks,
>
>        Ingo
>

  Yes,  this should be a cleaner step but it requires some more code churn that
is why I think Suresh' approach is pretty well done! Ingo, probably we could
do so on *top* of this changes as only time permits? The problem is that I
personally can't guarantee I continue working on the task this week, if Suresh
is able to -- this would be great, if not -- probably even such
minimal disturbing
patch worth merging, it definitley makes code better I think ;)
