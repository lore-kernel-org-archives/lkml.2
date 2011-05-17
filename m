Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1EQAja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 20:39:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1EQAj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 20:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U/n0SBc0jesQNfMJJLV0GTTThT5MiNDKCYsa8hHaV7QGTXpb1qxU4m7SDkFO9D9MLL
         m8GqEsQPkRmHYRHpjgbkbVQCZnrCO8CvuQXIuFlaZiflfj8GAY67t8RCxSbWKhbeaybP
         KLRFmmzEhR+AWWj3N9AbtcioEJnCWdlw1kQUc=
MIME-Version: 1.0
In-Reply-To: <1305324962.2781.5.camel@pasglop>
References: <1305317680.21099.83.camel@dwillia2-linux>
	<BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
	<4DCDA663.2040202@intel.com>
	<1305324962.2781.5.camel@pasglop>
Date: Mon, 16 May 2011 17:39:26 -0700
X-Google-Sender-Auth: O1rQKre-f_akfpjvzqWDWLaVwNc
Message-ID: <BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com>
Subject: Re: [GIT PULL] isci merge candidate
From: Dan Williams <dan.j.williams@intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Milburn <dmilburn@redhat.com>,
        "Ciechanowski, Ed" <ed.ciechanowski@intel.com>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Danecki, Jacek" <jacek.danecki@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>,
        Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 3:16 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>> It's a SAS (serial-attached-scsi) driver so it ties in to libsas rather
>> than libata (libsas itself ties in to libata for tunnelling SATA
>> protocol over SAS).  The size is attributable to the fact that all
>> protocol handling for non-fast path i/o is handled by software.  There
>> are still cleanups that can be made, but likely not on the on the same
>> order of what we have already done.
>
> How much of that non-fast-path could/should be in generic code vs. in
> the driver specific code ? IE. If somebody comes up with another "dumb"

I prefer the word "thin" :-), where "fat" refers to controllers that
hide this logic in offload cpu's, firmware, and or custom asics.

> SAS adapter tomorrow that doesn't do all that magic in an offload CPU,
> is any of that code re-usable ?

At a minimum It would require a more verbose interface to
libsas/libata (or new libframe?) to allow us to deliver raw
unsolicited frames into common protocol handlers.  The concern would
be wrangling different sets of protocol states and exception
conditions that individual vendors would choose to/not to offload.  To
date no other libsas based controller has taken this approach.

--
Dan
