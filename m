Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0EXRfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:35:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43230 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab0EXRfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eIhqICiWxV39XIhLY5nWnlj9npOAPSIlxnuaqekXCos9m2wwWi7P9SGdCG1Cypni2k
         0KR6EX35xYZJpaJXU7aeAq4gSCuds3cRsIUeB0X37UTeio4wBL9KqWi37mrqbKFYe32h
         r2sy/Ge+uMOdyemJjWPAqzbEJQpYaIbuf+ifY=
MIME-Version: 1.0
In-Reply-To: <20100524155506.GA7145@sgi.com>
References: <4BF2392A.9040409@jp.fujitsu.com>
	 <1274204560.17703.82.camel@Joe-Laptop.home>
	 <20100518185305.GA23921@elte.hu>
	 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
	 <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org>
	 <20100518222832.GJ22675@basil.fritz.box>
	 <m1wrv0zo9q.fsf@fess.ebiederm.org>
	 <AANLkTilxFZygP7YJybluPxtdxVGqWeqR4g7CRr8EEocW@mail.gmail.com>
	 <20100524155506.GA7145@sgi.com>
Date: Mon, 24 May 2010 10:35:21 -0700
X-Google-Sender-Auth: c9W7mbj4Vn1pM77MO21O1NFnc_s
Message-ID: <AANLkTin8jmZCm9801Jh-6mGHsJcx5dsCKwsSyn8SbBPc@mail.gmail.com>
Subject: Re: Hardware Error Kernel Mini-Summit
From: Tony Luck <tony.luck@intel.com>
To: Russ Anderson <rja@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 8:55 AM, Russ Anderson <rja@sgi.com> wrote:
> ia64 had the Intel defined MCA Spec which defined the interaction
> between SAL and the kernel.  x86 does not have a similar well
> defined way of how errors should be handled.  It would be
> good to agree on how the errors should be handled.

X86 has machine check registers defined by the SDM. It also
has some f/w <-> OS interactions defined by the APEI sections
in the latest ACPI spec (chapter 17 of the 4.0a spec released
last month - see http://acpi.info). Some parts look cleaner than
the ia64 SAL spec. E.g. errors logged from before the current
OS booted are presented in the Boot Error Record Table instead
of just appearing among the stream of errors that SAL_GET_ERROR
provides to the OS without any way to distinguish current errors
from old ones.

-Tony
