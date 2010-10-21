Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0JUGsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:48:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab0JUGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RyK31E5Zv8pxjwc/deZxowkNFa+COzBzvTElVRKJjHDEPZmcIwoLMWyR/uCLL5lsVb
         swSSU9UtfKWnrU3huZbVX4qEupJFXXpEcv42X8SzolJ+VDmhKjKscltMLB7eM/NwmqhN
         /O7vYg3eBUIweP3e9jMtT4ovFNSQQHXMYyw1I=
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
In-Reply-To: <20101021061701.GA17054@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
	 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
	 <20101021013833.GA21863@sli10-conroe.sh.intel.com>
	 <1287639230.2545.117.camel@edumazet-laptop> <4CBFD5A6.3060308@zytor.com>
	 <1287641277.4507.23.camel@edumazet-laptop> <4CBFD92B.5090503@zytor.com>
	 <20101021061701.GA17054@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 08:48:05 +0200
Message-ID: <1287643685.4507.110.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 14:17 +0800, Shaohua Li a écrit :
> This isn't a previous bug. see
> #define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)			\
> 	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
> 	__aligned(PAGE_SIZE)
> the ..page_aligned is already page aligned. I add it is because it can make
> the .readmostly section guarantee to have no cache false sharing, because
> I add the . = ALIGN(PAGE_SIZE); before .readmostly section, and .page_aligned
> follows, but for sure this wates some memory.

A small note:

The __aligned(XXX) makes sure object _starts_ at XXX boundary, not that
following one will also use same alignment. Of course, we can argue that
we dont try to put in PAGE_ALIGNED section small objects, but still...

Explicit .ALIGN() uses in .lds are more readable IMHO...



