Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2E3Qer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:34:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38932 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2E3Qep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6zU898KBv+vFFkymMjpDrPokj0dJq9MMX0z6WZOALbmQ@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
 <20120525043651.GA1391@google.com> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
 <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
 <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
 <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
 <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
 <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
 <CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
 <4FC50E09.4000204@zytor.com> <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
 <CAErSpo4ywho4UmPVAjT7yZNROc9e1zCx+UoaS5un+v4aN=akJA@mail.gmail.com>
 <CAE9FiQWORRjxEQwr+933ReNAAKAEoJ5B6AWte4gr33_BO+4heQ@mail.gmail.com>
 <CAErSpo44TViNFcZivjr5hAu8w8kpEpUjxNAWtazhAqwwsorZbw@mail.gmail.com>
 <4FC5CEF1.6000509@snewbury.org.uk> <CAErSpo6zU898KBv+vFFkymMjpDrPokj0dJq9MMX0z6WZOALbmQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 09:33:00 -0700
X-Google-Sender-Auth: qh-tNfBmpgKx-R23__q4wZyMvnQ
Message-ID: <CA+55aFzeG4a1gAxTp1G6252xCrxpB=5x_aDkjtU4WY0o0nqC+w@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 9:27 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> You're right, the spec does allow the upper 16 bits of I/O BARs to be
> hardwired to zero (PCI spec rev 3.0, p. 226), so this part does make
> some sense.  I don't think it applies to x86, since I don't think
> there's a way to generate an I/O access to anything above 64K, but it
> could help other arches.
>
> I'm inclined to be conservative and wait until we find a problem where
> a patch like this would help.

I agree. I would be *very* suspicious of "it might help with other
architectures".

Sure, other architectures might be using non-16-bit IO addresses for
their motherboard resources (just because they can). However, any
hotplug device is most likely (by far) to have been tested and
designed for x86, which means that even if it might look like it has
more than 16 bits of IO space, it will never have been tested that
way.

So rather than make it likely to help other architectures, I'd say
that it would make it likely to break things.

                 Linus
