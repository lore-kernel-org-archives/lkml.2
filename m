Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1DFAN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 20:13:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1DFANx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 20:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Npg21toi1v9cvkdFztVfKcF/cnzG8gW1uF5+UqmC9uhsiC12OnuVEMc2jUxrnWQM7s
         JNCcszGqlpzqXxaJtSGA==
MIME-Version: 1.0
In-Reply-To: <20110406000528.GB21350@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
	<20110405223814.GA21350@ericsson.com>
	<BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
	<20110406000528.GB21350@ericsson.com>
Date: Tue, 5 Apr 2011 17:13:50 -0700
Message-ID: <BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
From: Natarajan Gurumoorthy <natg@google.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
      How would you partition it out? Are you suggesting that we do
the following:

Patch1:
   drivers/hwmon/Kconfig          |    1 +
   drivers/hwmon/it87.c           |   14 ++++++++++++-

Patch2:
   drivers/watchdog/Kconfig       |   12 +++++++++++
   drivers/watchdog/Makefile      |    1 +
   drivers/watchdog/it8712f_wdt.c |   10 ++++----
   drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
   drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------

Patch3:
   include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++

Nat

On Tue, Apr 5, 2011 at 5:05 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Tue, Apr 05, 2011 at 07:03:35PM -0400, Natarajan Gurumoorthy wrote:
>> Guenter,
>>        This patch patch applies a common fix to all IT87 driver. Separating it
>> into 2 patches (one for drivers/hwmon and one for drivers/watchdog) does not
>> seem to be the right thing to do. I think having all the patches in one file
>> makes it easier to understand the rationale behind the patch. The
>> it87_io_lock.c and it87_io_lock.h files are in drivers/watchdog directory and
>> the lock defined in it is needed by the changes in drivers/hwmon/it87.c
>>
>
> I dislike the idea of a single patch crossing multiple subsystems. Maybe you'll
> find another maintainer accepting your change as a single patch, but I won't.
>
> That doesn't mean that the patches would have to be committed into multiple trees.
> That is for the subsystem maintainers to sort out, and a different issue.
>
> Thanks,
> Guenter
>



--
Regards
Nat Gurumoorthy AB6SJ
