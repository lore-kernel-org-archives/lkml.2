Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1BFQDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:03:02 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24414 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1BFQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:03:00 -0500
Date: Sun, 6 Feb 2011 08:01:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: akpm@linux-foundation.org, rmthomas@sciolus.org,
        driverdevel <devel@driverdev.osuosl.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] staging/easycap: fix build when SND is not
 enabled
Message-Id: <20110206080112.22f858e6.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikt=Ytey-n-YYGuXzJWNprEb-_zjuP5YjJGuvgK@mail.gmail.com>
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
	<20110205093632.b76be846.randy.dunlap@oracle.com>
	<AANLkTikt=Ytey-n-YYGuXzJWNprEb-_zjuP5YjJGuvgK@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D4EC62A.0014:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011 09:25:28 +0200 Tomas Winkler wrote:

> On Sat, Feb 5, 2011 at 7:36 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > Fix easycap build when CONFIG_SOUND is enabled but CONFIG_SND is
> > not enabled.
> >
> > These functions are only built when CONFIG_SND is enabled, so the
> > driver should depend on SND.
> > This means that having SND enabled is required for the (obsolete)
> > EASYCAP_OSS config option.
> 
> Actually SND enabled is needed when EASYCAP_OSS is NOT set.

I suspected that might be the case.

> I'm not sure, though how to force it in Kconfig,
> I didn't want to use choice ALSA, OSS as the OSS will be removed later.
> 
> Unfortunately I cannot do something like
> if EASYCAP_OSS == n
>     select SND
> endif

You can do
	select SND if !EASYCAP_OSS
but that may be too late or in the wrong location.

> I will try to come with proper fix

Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
