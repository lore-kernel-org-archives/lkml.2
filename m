Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab1HaQwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:52:31 -0400
Received: from nm26.bullet.mail.bf1.yahoo.com ([98.139.212.185]:38130 "HELO
	nm26.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756808Ab1HaQw3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:52:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 373129.88881.bm@omp1034.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=N1/i84A01xePcM1uu+DjhyiTGlDyBfd/7UkJ1OxjAJtay7i4ENTCWEaL8w3mxXZZKQT61MIFGH0YPobwrrdMsgpQPn8VHWc3nv6zwvhcXzlJVuWWIlzrglflslGfwPYLjOGgCvKiXUAO17B38pL4CH9n0AZCasmKdx+dkfGDqxA=;
X-YMail-OSG: uswjvfYVM1lgkV8tF7ku6pqmk7Zdu4sJvD_xcjjmnpOQBFQ
 deGKFiVkSi8JFCy.MSMCsQ0Nwi0AY1mbHCp82Y_sY96qRKjbtVjfqxCK18iF
 cgtTTDY03G68._O.rNb8xby.z4VNFP5bjpdX3DM7kmtjJxEc8Tj9tSLF.U6C
 hn3i4VeIw3La_hfo90zU6nMUEu..V01XpiFUSxPFuzp0dAqyi_oFuwE7iRSw
 be.lpVQSo324lr..yqYDWvRiBPN12KYfMVmQlRi5SPbNGNmrdzcyWzqLvJoq
 eyUjdO5tCDIRIVjFa6qqAasYJoa.OVgBklGEvw7Ns0lul.7Itn7F4pzex.Xk
 nWWnZjDmwoKnBWJPU8prLP7C.h21KzuhsTGk3jgWgNKDNIrlq_kP4TmSc.Ib
 MIo6dc1SFzT1nrWVrQDOdEnZ0fiIACk36X.2Raj7ICU6ycflEk3FeRCH77XB
 PouFWsVkz8o41.cCpSSkY62uZb1tfPw7D16GdiQnW8og9RGorbz8iFGbrB1j
 o1woyA0fzVKfjh8P1NkV675pDf2MQRhorYbl1o2Odydc-
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com> <CAA9_cmc3RWUFsWkyO4qnTLbVTmcGv51Ab8LyJqJUbNHbnx0kCg@mail.gmail.com>
Message-ID: <1314809546.41862.YahooMailNeo@web31808.mail.mud.yahoo.com>
Date: Wed, 31 Aug 2011 09:52:26 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@parallels.com>,
        Jack Wang <jack_wang@usish.com>
In-Reply-To: <CAA9_cmc3RWUFsWkyO4qnTLbVTmcGv51Ab8LyJqJUbNHbnx0kCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

> From: Dan Williams <dan.j.williams@intel.com>
> To: Luben Tuikov <ltuikov@yahoo.com>
> Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "JBottomley@Parallels.com" <JBottomley@parallels.com>; Jack Wang <jack_wang@usish.com>
> Sent: Wednesday, July 27, 2011 1:32 PM
> Subject: Re: [PATCH] [SCSI] libsas: remove expander from dev list on error
> 
> On Tue, Jul 26, 2011 at 11:10 PM, Luben Tuikov <ltuikov@yahoo.com> wrote:
>>  If expander discovery fails (sas_discover_expander()),
>>  remove the expander from the port device list
>>  (sas_ex_discover_expander()), before freeing it. Else
>>  the list is corrupted and, e.g., when we attempt to send
>>  SMP commands to other devices, the kernel oopses.
>> 
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>  Reviewed-by: Jack Wang <jack_wang@usish.com>
>>  ---
>>   drivers/scsi/libsas/sas_expander.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>> 
>>  diff --git a/drivers/scsi/libsas/sas_expander.c 
> b/drivers/scsi/libsas/sas_expander.c
>>  index 874e29d..f84084b 100644
>>  --- a/drivers/scsi/libsas/sas_expander.c
>>  +++ b/drivers/scsi/libsas/sas_expander.c
>>  @@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
>> 
>>          res = sas_discover_expander(child);
>>          if (res) {
>>  +               spin_lock_irq(&parent->port->dev_list_lock);
>>  +               list_del(&child->dev_list_node);
>>  +               spin_unlock_irq(&parent->port->dev_list_lock);
>>                  kfree(child);
>>                  return NULL;
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...but it raises a couple questions for potential follow on patches:
> 
> 1/ Do we need to add the device to port->dev_list prior to the
> discovery?  Seems cleaner to defer the list_add until after the
> discovery has succeeded.

In my original SAS Transport layer, devices were added to the
port device list in one and only one place, after discovery,
at sas_kobj_set() (which doesn't exist now because my code was
edited off-line before being submitted into the kernel by Bottomley).
Thus due to the architecture of the code, this bug doesn't exist in my original
implementation, but was introduced in the version submitted by Bottomley,
when devices are being added to the port list in more than one place.

My development git history was removed as the code was taken
off my git trees, edited off line, off git, and then submitted, thus erasing
its original state or its development history (in git). So it's now impossible
for a 3rd party to see what bugs were introduced due to those off-line
changes before submission.

And as you can see, there are bugs. The bugs are, as I can see, stemming
from the current _explicitness_ of libsas, a la, just-in-place fix, as if
someone has been studying the code by line-stepping it with a debugger,
and then going "A-ha! Here is where we can stick this in." SATA support
seems to have been added in a similar manner, "where can we stick this
to get it to work". I.e. there is no grand architecture, no vision.

The original code, was much more implicit: you had to pull back to see
what was happening.

It was designed as a transport layer. For example, for a new SAS
controller, you'd only need to write a PCI device driver which exposed
the ASIC's particular domain access implementation in a structure
of function pointers, that the PCI LLDD fills in, and the SAS Transport
Layer (SAS TL) fills in, and this is how both communicate. Then,
the SAS TL would register with the SCSI layer. It was a beautiful solution
of enterprise quality and design. SATA support was added in 2006 which
is _not_ libsata, but also a layer of abstraction with a structure of function
pointers, in effect allowing you to register a SATA device on _any_ transport
protocol, not only SAS, as a matter of filling in the stubs of a few function pointers.
(Thus also allowing you to easily emulate a SATA device if you so desire.)

The original SAS TL, also represented the whole SAS domain in sysfs,
exactly as it would look like in the physical world and was thus really
easy to do "tree -d" and then look at your work bench or rack and see
what is connected to what or what is missing or has been added.
See this http://marc.info/?l=linux-scsi&m=112629509826900&w=2,
for example.

The event infrastructure, removed by Bottomley, allowed for an infinite number
of events in a finite amount of memory. Removing it, introduced a few bugs, which
were I believe fixed back then, but it is impossible to know how many more there are.

> 2/ We have unlocked list manipulations in sas_ex_discover_end_dev(),
> sas_unregister_common_dev(), and sas_ex_discover_end_dev()

Yes, I can see that and that is very unfortunate. And as I mentioned, this
doesn't exist in the original design of the code. The point is that after
the changes offline people using Linux end up with substandard
and mediocre implementation of SAS.

Locking and coherency were achieved via the kobj infrastructure which was
a beautiful thing at the time, but has seen its number of changes beginning
in 06-07 (git can help there).

   Luben
